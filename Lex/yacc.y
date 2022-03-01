%union {
	int nombre;
    char id[50];
}
%{
#include <stdio.h>
int yylex();
%}

%token tMAIN
%token tOBRACKET tCBRACKET
%token<nombre> tOBRACE tCBRACE
%token tOCROCH tCCROCH
%token tINT
%token tCONST
%token tPV tCOMA
%token tMUL tDIV tADD tSUB tEQ
%token<nombre> tNB tNBEXP
%token<id> tID
%token tPRINTF tGET tSTOP
%token tERROR
%token<nombre> tIF tWHILE tELSE
%token tRETURN
%token tINF tSUP tEQCOND
%token tAND tOR
%token tADDR 
%left tLT tGT
%left tEQCOND
%left tAND tOR
%left tNOT
%left tADD tSUB
%left tMUL tDIV

%%


Main : tINT tMAIN tOBRACE Params tCBRACE  { printf("Main reconnu\n"); } ; 
Params :   { printf("Sans Params\n"); } ;
Params : Param SuiteParams ;
Param  : tINT tID { printf("Prametre : %s\n", $2); };
SuiteParams : tCOMA Param SuiteParams ;
SuiteParams : ;

%%

