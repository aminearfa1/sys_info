%{
#include <stdlib.h>
#include <stdio.h>
%}

%%

"main"      { printf("tMAIN\n");} 
"{"         { printf("tOBRACKET\n"); }
"}"         { printf("tCBRACKET\n"); }
"const"     { printf("tCONST\n"); }
"int"       { printf("tINT\n"); }
"printf"    { printf("tPRINTF\n"); } 
"("			{ printf("tOBRACE\n"); }
")"			{ printf("tCBRACE\n"); }
"if"        { printf("tIF\n");}
"while"     { printf("tWHILE\n");}
"<"         { printf("tINF\n");}
">"         { printf("tSUP\n");}
"=="        { printf("tEQCOND\n");}
"&&"        { printf("tAND\n");}
"||"        { printf("tOR\n");}
"else"      { printf("tELSE\n");}
[0-9]+	{ printf("tNB\n"); }     //atoi(yytext);
[0-9]+e[0-9]+	{ printf("tNBEXP\n"); } 
"+"			{ printf("tADD\n"); }
"-"			{ printf("tSUB\n"); }
"*"         { printf("tMUL\n"); }
"/"         { printf("tDIV\n"); }
"="         { printf("tEQ\n"); }
";"			{ printf("tPV\n"); }
" "			{ printf("tSPACE\n"); } 
"   "       { printf("tTAB\n"); } 
","         { printf("tCOMA\n"); }
"\n"        { printf("tRC\n") ; } 
[a-zA-Z][a-zA-Z0-9_]* { printf("tVAR\n"); }   //strcpy(yytext);
.				{ printf (" tERROR\n" );}
%%

int main () {

	yylex();
	return 1;
}

int yywrap(void){return 1;}
