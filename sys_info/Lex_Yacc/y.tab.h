/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    tMAIN = 258,
    tOBRACKET = 259,
    tCBRACKET = 260,
    tOBRACE = 261,
    tCBRACE = 262,
    tOCROCH = 263,
    tCCROCH = 264,
    tINT = 265,
    tCONST = 266,
    tPV = 267,
    tCOMA = 268,
    tMUL = 269,
    tDIV = 270,
    tADD = 271,
    tSUB = 272,
    tEQ = 273,
    tNB = 274,
    tNBEXP = 275,
    tID = 276,
    tPRINTF = 277,
    tGET = 278,
    tSTOP = 279,
    tERROR = 280,
    tIF = 281,
    tWHILE = 282,
    tELSE = 283,
    tRETURN = 284,
    tLT = 285,
    tGT = 286,
    tEQCOND = 287,
    tAND = 288,
    tOR = 289,
    tADDR = 290,
    tNOT = 291
  };
#endif
/* Tokens.  */
#define tMAIN 258
#define tOBRACKET 259
#define tCBRACKET 260
#define tOBRACE 261
#define tCBRACE 262
#define tOCROCH 263
#define tCCROCH 264
#define tINT 265
#define tCONST 266
#define tPV 267
#define tCOMA 268
#define tMUL 269
#define tDIV 270
#define tADD 271
#define tSUB 272
#define tEQ 273
#define tNB 274
#define tNBEXP 275
#define tID 276
#define tPRINTF 277
#define tGET 278
#define tSTOP 279
#define tERROR 280
#define tIF 281
#define tWHILE 282
#define tELSE 283
#define tRETURN 284
#define tLT 285
#define tGT 286
#define tEQCOND 287
#define tAND 288
#define tOR 289
#define tADDR 290
#define tNOT 291

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 1 "yacc.y"

	int nombre;
    char id[30];

#line 134 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
