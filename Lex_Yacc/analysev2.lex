%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

%%
"{" return T_OPEN_BRAC;
"}" return T_CLOSE_BRAC;
const {yylval.v3 = strdup(yytext);return T_CONST_TYPE;}
int {yylval.v3 = strdup(yytext);return T_INT_TYPE;}
float {yylval.v3 = strdup(yytext);return T_FLOAT_TYPE;}
double {yylval.v3 = strdup(yytext);return T_DOUBLE_TYPE;}
[0-9]+  {yylval.v1 = atoi(yytext); return T_INT;}
[0-9]+[\.][0-9]+ return T_FLOAT;
return return T_RETURN;
"+" return T_ADD;
"-" return T_SUB;
"*" return T_MUL;
"/" return T_DIV;
"+=" return T_ADD_EQ;
"-=" return T_SUB_EQ;
"*=" return T_MUL_EQ;
"/=" return T_DIV_EQ;
"=" return T_EQUALS;
"(" return T_OPEN_PAR;
")" return T_CLOSE_PAR;
">" return T_LOGICAL_SUP;
"<" return T_LOGICAL_INF;
"&&" return T_LOGICAL_AND;
"||" return T_LOGICAL_OR;
">=" return T_LOGICAL_SUP_EQ;
"<=" return T_LOGICAL_INF_EQ; 
"==" return T_LOGICAL_EQ;
"!=" return T_LOGICAL_NEQ;
"!" return T_LOGICAL_NOT;

if return T_IF;
else return T_ELSE;
while return T_WHILE;
[\n\t\ ]+ {};
, return T_COMA;
; return T_END_INSTRUCT;
printf\(.*\) return T_PRINTF;
[A-z][A-z0-9_]* {yylval.v3 = strdup(yytext); return T_VARNAME;}

%%
int yywrap()
{
    return 1;
}
"{" return T_OPEN_BRAC;
"}" return T_CLOSE_BRAC;
const {yylval.v3 = strdup(yytext);return T_CONST_TYPE;}
int {yylval.v3 = strdup(yytext);return T_INT_TYPE;}
float {yylval.v3 = strdup(yytext);return T_FLOAT_TYPE;}
double {yylval.v3 = strdup(yytext);return T_DOUBLE_TYPE;}
[0-9]+  {yylval.v1 = atoi(yytext); return T_INT;}
[0-9]+[\.][0-9]+ return T_FLOAT;
return return T_RETURN;
"+" return T_ADD;
"-" return T_SUB;
"*" return T_MUL;
"/" return T_DIV;
"+=" return T_ADD_EQ;
"-=" return T_SUB_EQ;
"*=" return T_MUL_EQ;
"/=" return T_DIV_EQ;
"=" return T_EQUALS;
"(" return T_OPEN_PAR;
")" return T_CLOSE_PAR;
">" return T_LOGICAL_SUP;
"<" return T_LOGICAL_INF;
"&&" return T_LOGICAL_AND;
"||" return T_LOGICAL_OR;
">=" return T_LOGICAL_SUP_EQ;
"<=" return T_LOGICAL_INF_EQ; 
"==" return T_LOGICAL_EQ;
"!=" return T_LOGICAL_NEQ;
"!" return T_LOGICAL_NOT;

if return T_IF;
else return T_ELSE;
while return T_WHILE;
[\n\t\ ]+ {};
, return T_COMA;
; return T_END_INSTRUCT;
printf\(.*\) return T_PRINTF;
[A-z][A-z0-9_]* {yylval.v3 = strdup(yytext); return T_VARNAME;}

%%
int yywrap()
{
    return 1;
}
