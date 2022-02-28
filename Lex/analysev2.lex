%{
#include <stdlib.h>
#include <stdio.h>
%}

%%

"main"      { return  tMAIN;} 
"{"         { return tOBRACKET;}
"}"         { return tCBRACKET;}
"const"     { return tCONST;}
"int"       { return tINT;}
"printf"    { return tPRINTF;} 
"("			{ return tOBRACE;}
")"			{ return tCBRACE;}
"if"        { return tIF; }
"while"     { return tWHILE; }
"<"         { return tINF; }
">"         { return tSUP; }
"=="        { return tEQCOND; }
"&&"        { return tAND; }
"||"        { return tOR; }
"else"      { return tELSE;}
[0-9]+	{ return tNB;}
[0-9]+e[0-9]+	{ return tNBEXP;} 
"+"			{ return tADD;}
"-"			{ return tSUB;}
"*"         { return tMUL;}
"/"         { return tDIV;}
"="         { return tEQ;}
";"			{ return tPV;}
" "			{ return tSPACE;} 
"   "       { return tTAB;} 
","         { return tCOMA;}
"\n"        { return tRC;} 
[a-zA-Z][a-zA-Z0-9_]* { return tVAR;}
.				   	{ return tERROR;}
%%

int main () {

	yylex();
	return 1;
}

int yywrap(void){return 1;}
