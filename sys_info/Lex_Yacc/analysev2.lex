%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

%%

"main"      { return tMAIN ;} 
"{"         { return tOBRACKET;}
"}"         { return tCBRACKET; }
"("			{ return tOBRACE; }
")"			{ return tCBRACE; }
"const"     { return tCONST; }
"int"       { return tINT; }
"printf"    { return tPRINTF; } //Degeu mais à degager
"if"        { return tIF; }
"while"     { return tWHILE; }
"return"    {return tRETURN; }
"<"         { return tINF; }
">"         { return tSUP; }
"=="        { return tEQCOND; }
"&&"        { return tAND; }
"||"        { return tOR; }
"else"      { return tELSE;}
"&"         { return tADDR;}
"["         { return tOCROCH;}
"]" 		{ return tCCROCH;}
"get"       { return tGET;}
"stop"      { return tSTOP;}
[0-9]+	{ yylval.nombre = atoi(yytext); return tNB; }
[0-9]+e[0-9]+	{ yylval.nombre = -1; return tNBEXP; } //Renvoyer le token tNB et pas tNBEXP
"+"			{ return tADD; }
"-"			{ return tSUB; }
"*"         { return tMUL; }
"/"         { return tDIV; }
"="         { return tEQ; }
";"			{ return tPV; }
" "			{} //Ne pas les retourner à Yacc
"   "       {} //Ne pas les retourner à Yacc
","         { return tCOMA; }
"\n"        {} //Ne pas les retourner à Yacc
[a-zA-Z][a-zA-Z0-9_]* { strcpy(yylval.id, yytext); return tID; }
.				{ }//return tERROR; }
%%

int yywrap(void){return 1;}

 void yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}
