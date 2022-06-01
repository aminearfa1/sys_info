%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "src/symbol_table.h"
#include "src/opTable.h"
#include "src/memory_z.h"
#include "src/util.h"

#define MAX_SIZE 100

int yylex();
int yyeror();

int global_depth = 0;
int lastType = 1;
int cptInstr= 0;
int whileJumpMem;
headMZ *global_pointer_zone, *mem;
Symbol_table *head_table; 

char *arrayInstr[MAX_INSTRUCT];

%}

%union {int v1; double v2; char *v3; int v4;}
%token T_OPEN_BRAC T_CLOSE_BRAC
%token T_CONST_TYPE T_INT_TYPE T_FLOAT_TYPE T_DOUBLE_TYPE
%token T_INT T_FLOAT
%token T_RETURN

%token T_ADD T_SUB T_MUL T_DIV T_EQUALS
%token T_ADD_EQ T_SUB_EQ T_MUL_EQ T_DIV_EQ
%token T_OPEN_PAR T_CLOSE_PAR

%token T_LOGICAL_SUP T_LOGICAL_INF
%token T_LOGICAL_AND T_LOGICAL_OR
%token T_LOGICAL_SUP_EQ T_LOGICAL_INF_EQ
%token T_LOGICAL_EQ T_LOGICAL_NEQ T_LOGICAL_NOT


%token T_IF T_ELSE
%token T_WHILE
%token T_COMA

%token T_END_INSTRUCT
%token T_PRINTF
%token T_VARNAME 

%type <v1> T_INT T_IF T_ELSE T_WHILE
%type <v2> T_FLOAT 
%type <v3> VAR_TYPE T_VARNAME T_CONST_TYPE T_INT_TYPE T_FLOAT_TYPE T_DOUBLE_TYPE
%type <v4> NUMBER EXPR RETURN DECLARATION CONDITION
%type <v4> AFFECTATION AFFECTATION_EQ AFFECTATION_DECLARATION SUITE_DECLARATION
%type <v4> CALL_FUNCTION

%right T_EQUALS

%left T_LOGICAL_OR
%left T_LOGICAL_AND
%left T_LOGICAL_EQ T_LOGICAL_NEQ
%left T_LOGICAL_SUP_EQ T_LOGICAL_INF_EQ T_LOGICAL_SUP T_LOGICAL_INF
%left T_LOGICAL_NOT
%left T_ADD T_SUB
%left T_MUL T_DIV

%%

//Un programme, plusieurs fonctions, le main en dernier
DEBUT:  
	FUNCTIONS
		{
			printArray(arrayInstr, cptInstr);
			save_all_lines(arrayInstr, cptInstr);
			print_table(head_table);
		}
	; 

FUNCTIONS:
		DECLARE_FUNCTION FUNCTIONS
		| 
		;


/* Corps d un programme : 
	"{
		suite d'instructions
	}" 
*/
CORPS: 
    T_OPEN_BRAC 
		{ global_depth++;} 
	INSTRUCTIONS T_CLOSE_BRAC 
		{ global_depth--; }
	;

INSTRUCTIONS: 
		INSTRUCTION INSTRUCTIONS 
		| 
		; 

//Les instructions sont :
// Des déclarations, des affectations (= et +=/-=/...), des appels de fonctions
// Des if, des while, la fonction printf (non utilisée),  zéro, un, ou plusieurs return
INSTRUCTION: 
		DECLARATION T_END_INSTRUCT
		| AFFECTATION T_END_INSTRUCT
		| AFFECTATION_EQ T_END_INSTRUCT
		| CALL_FUNCTION T_END_INSTRUCT
		| IF 
		| WHILE
		| T_PRINTF T_END_INSTRUCT
		| RETURN T_END_INSTRUCT
		; 

RETURN:
	T_RETURN EXPR 
		{
			setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
			sprintf(arrayInstr[cptInstr++], "PRI %d", $2);
			$$ = $2;
		}
	;

DECLARATION: 
		VAR_TYPE T_VARNAME SUITE_DECLARATION 
			{
				/*Dans le cas d'une déclaration simple, on regarde si le symbole n'existe pas déjà.
				  S'il existe, on affiche une erreur
				  Sinon on le crée et on renvoie son adresse */
				Symbol *s = getSymbol(head_table, $2);
				if(s != NULL){
					printf("error : var \"%s\" already exists\n", $2);
					exit(1);
				}
				int addr = getFreeAddress(global_pointer_zone, lastType);
				s = createSymbol(lastType, $2, addr, global_depth);
				insertSymbol(head_table, s);
				$$ = addr;
			}
		| VAR_TYPE AFFECTATION_DECLARATION SUITE_DECLARATION {$$ = $2;}
		; 

SUITE_DECLARATION:
		T_COMA T_VARNAME SUITE_DECLARATION
			{
				/*Dans le cas d'une déclaration simple, on regarde si le symbole n'existe pas déjà.
				  S'il existe, on affiche une erreur
				  Sinon on le crée et on renvoie son adresse */
				Symbol *s = getSymbol(head_table, $2);
				if(s != NULL){
					printf("error : var \"%s\" already exists\n", $2);
					exit(1);
				}
				int addr = getFreeAddress(global_pointer_zone, lastType);
				s = createSymbol(lastType, $2, addr, global_depth);
				insertSymbol(head_table, s);
				$$ = addr;
			} 
		| T_COMA AFFECTATION_DECLARATION SUITE_DECLARATION {$$ = $2;} 
		| 
		;
AFFECTATION_DECLARATION:
	T_VARNAME T_EQUALS EXPR	
		{
			/*Dans le cas d'une affectation dans une déclaration, 
			  on regarde si le symbole n'existe pas déjà.
			  S'il existe, on affiche une erreur
			  Sinon on le crée, on lui affecte la valeur de l'expression et on renvoie son adresse */
			Symbol *s = getSymbol(head_table, $1);
			if(s != NULL){
				printf("error : var \"%s\" already exists\n", $1);
				exit(1);
			}
			int addr = getFreeAddress(global_pointer_zone, lastType);
			s = createSymbol(lastType, $1, addr, global_depth);
			setInitialized(s);
			insertSymbol(head_table, s);

			setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
			sprintf(arrayInstr[cptInstr++], "COP %d %d", addr, $3);
			freeAddress(mem, $3, 1);
			$$ = addr;
		}
	;

//Affectation hors d'une déclaration
AFFECTATION: 
		T_VARNAME T_EQUALS EXPR
			{
				/*Dans le cas d'une affectation hors déclaration,
				  On regarde si le symbole existe.
				  S'il n'existe pas, on affiche une erreur
				  Sinon on affecte normalement */
				Symbol *s = getSymbol(head_table, $1);
				if(s == NULL){
					printf("error : var \"%s\" is not declared\n", $1);
					exit(1);
				}
				setInitialized(s);
				int addr = getAddress(s);
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "COP %d %d", addr, $3);
				freeAddress(mem, $3, 1);
				$$ = addr;
			}
		;

// opérateurs "+=, -=, *=, /=" 
//Il faut que le symbole existe et soit déjà initialisé pour utiliser ces opérateurs
AFFECTATION_EQ:
		T_VARNAME T_ADD_EQ EXPR
			{	
				Symbol *s = getSymbol(head_table, $1);
				if(s == NULL || !isInitialised(s)){
					printf("error : var \"%s\" not initialised\n", $1);
					exit(1);
				}

				int addr = getAddress(s);
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "ADD %d %d %d", addr, addr, $3);
				freeAddress(mem, $3, 1);
				$$ = addr;
			}
		| T_VARNAME T_SUB_EQ EXPR
			{
				Symbol *s = getSymbol(head_table, $1);
				if(s == NULL || !isInitialised(s)){
					printf("error : var \"%s\" not initialised\n", $1);
					exit(1);
				}

				int addr = getAddress(s);
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "SOU %d %d %d", addr, addr, $3);
				freeAddress(mem, $3, 1);
				$$ = addr;
			}
		| T_VARNAME T_MUL_EQ EXPR
			{
				Symbol *s = getSymbol(head_table, $1);
				if(s == NULL || !isInitialised(s)){
					printf("error : var \"%s\" not initialised\n", $1);
					exit(1);
				}

				int addr = getAddress(s);
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "MUL %d %d %d", addr, addr, $3);
				freeAddress(mem, $3, 1);
				$$ = addr;
			}
		| T_VARNAME T_DIV_EQ EXPR
			{
				Symbol *s = getSymbol(head_table, $1);
				if(s == NULL || !isInitialised(s)){
					printf("error : var \"%s\" not initialised\n", $1);
					exit(1);
				}

				int addr = getAddress(s);
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "DIV %d %d %d", addr, addr, $3);
				freeAddress(mem, $3, 1);
				$$ = addr;
			}
		;


VAR_TYPE: 
		T_FLOAT_TYPE {lastType = getTypeByName($1);}
		| T_DOUBLE_TYPE  {lastType = getTypeByName($1);}
		| T_INT_TYPE {lastType = getTypeByName($1);}
		;

/* Function declaration */
DECLARE_FUNCTION: 
		VAR_TYPE T_VARNAME
			{
				//On affiche une erreur si on détecte une autre fonction que le main
				if(strcmp($2, "main") != 0){
					printf("error : only main function is accepted\n");
					exit(1);
				}
			}
		T_OPEN_PAR DECLARE_PARAMETERS T_CLOSE_PAR CORPS
		;

DECLARE_PARAMETERS: 
		DECLARE_PARAMETER DECLARE_SUITEPARAM
		| 
		;

DECLARE_PARAMETER:
		VAR_TYPE T_VARNAME 
		;

DECLARE_SUITEPARAM:
		T_COMA DECLARE_PARAMETER DECLARE_SUITEPARAM
		| 
		;


/* Function call */
CALL_FUNCTION: 
		T_VARNAME T_OPEN_PAR CALL_PARAMETERS T_CLOSE_PAR
		{$$ = 0;}
		;

CALL_PARAMETERS: 
		CALL_PARAMETER CALL_SUITEPARAM
		| 
		;

CALL_PARAMETER: T_VARNAME
		;

CALL_SUITEPARAM:
		T_COMA CALL_PARAMETER CALL_SUITEPARAM
		| 
		;


/* Arithmetic expression*/
//Pour 
EXPR: 
		EXPR T_ADD EXPR
			{
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "ADD %d %d %d", $1, $1, $3);
				freeAddress(mem, $3, 1);
				$$ = $1;
			}
        | EXPR T_SUB EXPR
			{
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "SOU %d %d %d", $1, $1, $3);
				freeAddress(mem, $3, 1);
				$$ = $1;
			}
        | EXPR T_MUL EXPR
			{
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "MUL %d %d %d", $1, $1, $3);
				freeAddress(mem, $3, 1);
				$$ = $1;
			}
        | EXPR T_DIV EXPR
			{
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "DIV %d %d %d", $1, $1, $3);
				freeAddress(mem, $3, 1);
				$$ = $1;
			}
        | T_OPEN_PAR EXPR T_CLOSE_PAR
			{$$ = $2;}
    	| T_VARNAME 
			{
				//Il faut que le symbole existe et soit initialisé pour l'utiliser dans une expression
				Symbol *s = getSymbol(head_table, $1);
				if(s == NULL || !isInitialised(s)){
					printf("Var \"%s\" not initialised\n", $1);
					exit(1);
				}
				int varType = getType(s); 
				int addr = getAddress(s);
				int tmp = getFreeAddress(mem, varType);
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "COP %d %d",tmp, addr);
				$$ = tmp;
			}
		| CALL_FUNCTION
    	| NUMBER 
			{$$ = $1;}
		;
    

NUMBER:  
    	T_INT 
			{ 
				int addr = getFreeAddress(mem, getTypeByName("int"));
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "AFC %d %d",addr, $1);
				$$ = addr;
			}	 
    	| T_FLOAT
			{ 
				int addr = getFreeAddress(mem, getTypeByName("float"));
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "AFC %d %d",addr, $1);		
				$$ = addr;
			}	
		 ;



/* Logical condition */
CONDITION:
		CONDITION T_LOGICAL_AND CONDITION
			{
				/*ET logique : on multiplie les deux conditions et on compare le résultat à 0
				  Le résultat est égal à 1 si les deux conditions sont vraies */
				int addrConst = getFreeAddress(mem, getTypeByName("int"));
				int addrRes = getFreeAddress(mem, getTypeByName("int"));

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "AFC %d 0", addrConst);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "MUL %d %d %d", addrRes, $1, $3);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "SUP %d %d %d", addrRes, addrRes, addrConst);

				freeAddress(mem, $1, 1);
				freeAddress(mem, $3, 1);
				freeAddress(mem, addrConst, 1);

				$$ = addrRes;
			}

		| CONDITION T_LOGICAL_OR CONDITION
			{
				/*OU logique : on additionne les deux conditions, on compare le résultat à 0 
				  Le résultat est égal à 1 si au moins une des deux conditions est vraie */
				int addrConst = getFreeAddress(mem, getTypeByName("int"));
				int addrRes = getFreeAddress(mem, getTypeByName("int"));

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "AFC %d 0", addrConst);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "ADD %d %d %d", addrRes, $1, $3);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "SUP %d %d %d", addrRes, addrRes, addrConst);

				freeAddress(mem, $1, 1);
				freeAddress(mem, $3, 1);
				freeAddress(mem, addrConst, 1);

				$$ = addrRes;
			}

		| CONDITION T_LOGICAL_EQ CONDITION
			{
				//Instruction EQU
				int addr = getFreeAddress(mem, getTypeByName("int"));
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "EQU %d %d %d", addr, $1, $3);	

				freeAddress(mem, $1, 1);
				freeAddress(mem, $3, 1);

				$$ = addr;
			}
		| CONDITION T_LOGICAL_NEQ CONDITION
			{
				/*	NOT EQUALS : on regarde si les conditions sont égales.
					On additionne 1 au résultat précédent.
					On compare le nouveau résultat à 1.
					Si les conditions sont égales 			-> 1 -> 1+1 == 1 -> 0
					Si les conditions ne sont pas égales 	-> 0 -> 0+1 == 1 -> 1 */
				int addrConst = getFreeAddress(mem, getTypeByName("int"));
				int addrRes = getFreeAddress(mem, getTypeByName("int"));

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "AFC %d 1", addrConst);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "EQU %d %d %d", addrRes, $1, $3);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "ADD %d %d %d", addrRes, addrRes, addrConst);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "EQU %d %d %d", addrRes, addrRes, addrConst);

				freeAddress(mem, $1, 1);
				freeAddress(mem, $3, 1);
				freeAddress(mem, addrConst, 1);

				$$ = addrRes;
			}
		| CONDITION T_LOGICAL_SUP_EQ CONDITION
			{
				/*SUP OR EQUALS : on teste les 2 conditions SUP et EQU
				  Puis, comme pour le OU logique, on additionne les résultats de ces deux conditions
				  et on compare le nouveau résultat à 0
				  Si une des deux conditions est vraie, le résultat est égal à 1
				*/
				int addrConst = getFreeAddress(mem, getTypeByName("int"));
				int addrResEq = getFreeAddress(mem, getTypeByName("int"));
				int addrResSup = getFreeAddress(mem, getTypeByName("int"));

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "AFC %d 0", addrConst);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "SUP %d %d %d", addrResSup, $1, $3);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "EQU %d %d %d", addrResEq,  $1, $3);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "ADD %d %d %d", addrResSup, addrResSup, addrResEq);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "SUP %d %d %d", addrResSup, addrResSup, addrConst);


				freeAddress(mem, $1, 1);
				freeAddress(mem, $3, 1);
				freeAddress(mem, addrConst, 1);
				freeAddress(mem, addrResEq, 1);

				$$ = addrResSup;
			}
		| CONDITION T_LOGICAL_INF_EQ CONDITION
			{
				/*INF OR EQUALS : on teste les 2 conditions INF et EQU
				  Puis, comme pour le OU logique, on additionne les résultats de ces deux conditions
				  et on compare le nouveau résultat à 0
				  Si une des deux conditions est vraie, le résultat est égal à 1
				*/
				int addrConst = getFreeAddress(mem, getTypeByName("int"));
				int addrResEq = getFreeAddress(mem, getTypeByName("int"));
				int addrResInf = getFreeAddress(mem, getTypeByName("int"));

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "AFC %d 0", addrConst);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "INF %d %d %d", addrResInf, $1, $3);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "EQU %d %d %d", addrResEq,  $1, $3);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "ADD %d %d %d", addrResInf, addrResInf, addrResEq);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "SUP %d %d %d", addrResInf, addrResInf, addrConst);

				freeAddress(mem, $1, 1);
				freeAddress(mem, $3, 1);
				freeAddress(mem, addrConst, 1);
				freeAddress(mem, addrResEq, 1);

				$$ = addrResInf;
			}
		| CONDITION T_LOGICAL_SUP CONDITION
			{
				//Instruction SUP
				int addr = getFreeAddress(mem, getTypeByName("int"));
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "SUP %d %d %d", addr, $1, $3);	

				freeAddress(mem, $1, 1);
				freeAddress(mem, $3, 1);

				$$ = addr;
			}
		| CONDITION T_LOGICAL_INF CONDITION
			{
				//Instruction INF
				int addr = getFreeAddress(mem, getTypeByName("int"));
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "INF %d %d %d", addr, $1, $3);	

				freeAddress(mem, $1, 1);
				freeAddress(mem, $3, 1);

				$$ = addr;
			}
		| T_LOGICAL_NOT CONDITION	
			{
				/* NOT X : On soustrait la condition à elle même,
			      Puis on regarde si le résultat est égal à la condition
				  Si condition = 1 -> 1-1 == 1 -> 0
				  Si condition = 0 -> 0-0 == 0 -> 1 */
				int addrRes = getFreeAddress(mem, getTypeByName("int"));

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "SOU %d %d %d", addrRes, $2, $2);

				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "EQU %d %d %d", addrRes, addrRes, $2);

				freeAddress(mem, $2, 1);

				$$ = addrRes;
			}
		| T_OPEN_PAR CONDITION T_CLOSE_PAR
			{ $$ = $2; }
		| T_OPEN_PAR AFFECTATION T_CLOSE_PAR
			{
				//Une affectation est toujours vraie
				int addr = getFreeAddress(mem, getTypeByName("int")); 
				setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
				sprintf(arrayInstr[cptInstr++], "AFC %d 1",addr);		
				$$ = addr;
			}
    	| EXPR
			{$$ = $1;}
		;



/* If; Else If; Else */
IF:
    T_IF CONDITION 
		{
			$1 = cptInstr;
			storeJMF(arrayInstr, &cptInstr, $2, MAX_SIZE);
		}
	CORPS
		{
			patchLine(arrayInstr, $1, cptInstr+1, CHAR_TO_REPLACE);
		}
	SUITE_IF 
	;


SUITE_IF: 
	T_ELSE
		{
			$1 = cptInstr;
			storeJMP(arrayInstr, &cptInstr, MAX_SIZE);
		}
	IF
		{
			patchLine(arrayInstr, $1, cptInstr, CHAR_TO_REPLACE);
		}
	| T_ELSE 
		{
			$1 = cptInstr;
			storeJMP(arrayInstr, &cptInstr, MAX_SIZE);
		}
		CORPS
		{
			patchLine(arrayInstr, $1, cptInstr, CHAR_TO_REPLACE);
		}
	| 
		{
			setUpArrayInstr(arrayInstr, MAX_SIZE, cptInstr);
			strncpy(arrayInstr[cptInstr++], "NOP", 4);
		}
	;


WHILE:
	T_WHILE 
		{$1 = cptInstr;}
	CONDITION
		{
			whileJumpMem = cptInstr;
			storeJMF(arrayInstr, &cptInstr, $3, MAX_SIZE);
		}	
	CORPS 
	 	{
			storeJMP(arrayInstr, &cptInstr, MAX_SIZE);
			patchLine(arrayInstr, cptInstr-1, $1, CHAR_TO_REPLACE);
			patchLine(arrayInstr, whileJumpMem, cptInstr, CHAR_TO_REPLACE);
	 	}
	;
%%

int yyerror(void)
{ fprintf(stderr, "erreur de syntaxe\n"); return 1;}

int main(void){
	head_table = createHead();
	global_pointer_zone = initMem(2000,3000);
	mem = initMem(0,1000);
    yyparse();
}
