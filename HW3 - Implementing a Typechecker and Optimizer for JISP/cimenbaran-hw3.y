%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void yyerror (const char *s) 
{}

char * substring(char *, int, int);
extern int yylineno;
%}

%union{
	struct {
		char* str;
		int isNegative;
	} str;
	int inum;
	double fnum;
}

%locations


%token <inum> tINT
%token <fnum> tFLOAT
%token <str> tSTRING
%token tADD tSUB tMUL tDIV tPRINT tGET tSET tFUNCTION tRETURN tIDENT tEQUALITY tIF tGT tLT tGEQ tLEQ tINC tDEC


%type <inum> int intOp 
%type <fnum> float floatOp 
%type <str> str stringOp 
%start prog

%left tADD tSUB
%left tMUL tDIV

%%
prog:		'[' stmtlst ']'
;

stmtlst:	stmtlst stmt |
;

stmt:		setStmt | if | print | unaryOperation | expr | returnStmt
;

getExpr:	'[' tGET ',' tIDENT ',' '[' exprList ']' ']'
		| '[' tGET ',' tIDENT ',' '[' ']' ']'
		| '[' tGET ',' tIDENT ']'
;

setStmt:	'[' tSET ',' tIDENT ',' expr ']'
;

if:		'[' tIF ',' condition ',' '[' stmtlst ']' ']'
		| '[' tIF ',' condition ',' '[' stmtlst ']' '[' stmtlst ']' ']'
;

print:		'[' tPRINT ',' '[' expr ']' ']'
;

otherOp:	'[' tADD ',' oExpr ',' oExpr ']'
		| '[' tSUB ',' oExpr ',' oExpr ']' 
		| '[' tMUL ',' oExpr ',' oExpr ']' 
		| '[' tDIV ',' oExpr ',' oExpr ']' 

		| '[' tADD ',' oExpr ',' int ']'
		| '[' tSUB ',' oExpr ',' int ']' 
		| '[' tMUL ',' oExpr ',' int ']' 
		| '[' tDIV ',' oExpr ',' int ']' 
				
		| '[' tADD ',' int ',' oExpr ']'
		| '[' tSUB ',' int ',' oExpr ']' 
		| '[' tMUL ',' int ',' oExpr ']' 
		| '[' tDIV ',' int ',' oExpr ']' 
				
		| '[' tADD ',' oExpr ',' float ']'
		| '[' tSUB ',' oExpr ',' float ']' 
		| '[' tMUL ',' oExpr ',' float ']' 
		| '[' tDIV ',' oExpr ',' float ']' 
				
		| '[' tADD ',' float ',' oExpr ']'
		| '[' tSUB ',' float ',' oExpr ']' 
		| '[' tMUL ',' float ',' oExpr ']' 
		| '[' tDIV ',' float ',' oExpr ']' 
				
		| '[' tADD ',' oExpr ',' str ']'
		| '[' tSUB ',' oExpr ',' str ']' 
		| '[' tMUL ',' oExpr ',' str ']' 
		| '[' tDIV ',' oExpr ',' str ']' 
				
		| '[' tADD ',' str ',' oExpr ']'
		| '[' tSUB ',' str ',' oExpr ']' 
		| '[' tMUL ',' str ',' oExpr ']' 
		| '[' tDIV ',' str ',' oExpr ']' 

;


intOp: 		'[' tADD ',' int ',' int ']' { $$ = $4 + $6;}
		| '[' tSUB ',' int ',' int ']' { $$ = $4 - $6;}
		| '[' tMUL ',' int ',' int ']' { $$ = $4 * $6;}
		| '[' tDIV ',' int ',' int ']' { $$ = $4 / $6;}
;

floatOp: 	'[' tADD ',' float ',' float ']' { $$ = $4 + $6;}
		| '[' tSUB ',' float ',' float ']' { $$ = $4 - $6;}
		| '[' tMUL ',' float ',' float ']' { $$ = $4 * $6;}
		| '[' tDIV ',' float ',' float ']' { $$ = $4 / $6;}
		| '[' tADD ',' float ',' int ']' { $$ = $4 + $6;}
		| '[' tSUB ',' float ',' int ']' { $$ = $4 - $6;}
		| '[' tMUL ',' float ',' int ']' { $$ = $4 * $6;}
		| '[' tDIV ',' float ',' int ']' { $$ = $4 / $6;}
		| '[' tADD ',' int ',' float ']' { $$ = $4 + $6;}
		| '[' tSUB ',' int ',' float ']' { $$ = $4 - $6;}
		| '[' tMUL ',' int ',' float ']' { $$ = $4 * $6;}
		| '[' tDIV ',' int ',' float ']' { $$ = $4 / $6;}
;

stringOp:	'[' tADD ',' str ',' str']' { 
	char* s1 = $4.str;
	char* s2;

	int i;
	if(s1[0] == '\'') {
		for(i = 1; s1[i] != '\''; i++) {}

		if(i == 1)
			s2 = "";
		else {
			s2 = substring(s1, 2, i - 1);
		}
	} else {
		for(i = 0; s1[i] != '\0'; i++) {}
		s2 = substring(s1, 1, i);
	}
	char* s3 = $6.str;
	char* s4;
	if(s3[0] == '\'') {
		for(i = 1; s3[i] != '\''; i++) {}

		if(i == 1)
			s4 = "";
		else {
			s4 = substring(s3, 2, i - 1);
		}
	} else {
		for(i = 0; s3[i] != '\0'; i++) {}
		s4 = substring(s3, 1, i);
	}

	strcat(s2, s4);
	$$.str = s2;
}
		| '[' tMUL ',' int ',' str']' {
	char* s1 = $6.str;
	char* s2;

	int i;
	if(s1[0] == '\'') {
		for(i = 1; s1[i] != '\''; i++) {}

		if(i == 1)
			s2 = "";
		else {
			s2 = substring(s1, 2, i - 1);
		}
	} else {
		for(i = 0; s1[i] != '\0'; i++) {}
		s2 = substring(s1, 1, i);
	}

	char* res;
	if(s1[0] == '\'') {
		for(i = 1; s1[i] != '\''; i++) {}

		if(i == 1)
			res = "";
		else {
			res = substring(s1, 2, i - 1);
		}
	} else {
		for(i = 0; s1[i] != '\0'; i++) {}
		res = substring(s1, 1, i);
	}

	int x = $4;
	if(x == 0) {
		res = "";
	}

	if(x < 0) {
		$$.isNegative = 1;
	}

	for(i=1; i< x; i++) {
		strcat(res, s2);
	}
	$$.str = res;
}
;

unaryOperation: '[' tINC ',' tIDENT ']'
		| '[' tDEC ',' tIDENT ']'
;

expr: 		oExpr
		|	intOp { printf("Result of expression on %d is (%d)\n", @1.first_line, $1); }
		|	floatOp { {printf("Result of expression on %d is (%.1f)\n", @1.first_line, (($1*100)+0.5)/100);}}
		|	stringOp { if($1.isNegative == 1) {printf("Type mismatch on %d\n", @1.first_line);} else printf("Result of expression on %d is (%s)\n", @1.first_line, $1.str); }
		| 	invalidOp {printf("Type mismatch on %d\n", yylineno);}
		| 	tINT 
		| 	tFLOAT
		|	tSTRING
;

invalidOp: '[' tSUB ',' str ',' str ']' 
		| '[' tMUL ',' str ',' str ']' 
		| '[' tDIV ',' str ',' str ']' 

		| '[' tADD ',' int ',' str ']'
		| '[' tSUB ',' int ',' str ']' 
		| '[' tDIV ',' int ',' str ']' 
						
		| '[' tADD ',' str ',' int ']'
		| '[' tSUB ',' str ',' int ']' 
		| '[' tMUL ',' str ',' int ']' 
		| '[' tDIV ',' str ',' int ']' 
						
		| '[' tADD ',' str ',' float ']'
		| '[' tSUB ',' str ',' float ']' 
		| '[' tMUL ',' str ',' float ']' 
		| '[' tDIV ',' str ',' float ']' 
						
		| '[' tADD ',' float ',' str ']'
		| '[' tSUB ',' float ',' str ']' 
		| '[' tMUL ',' float ',' str ']' 
		| '[' tDIV ',' float ',' str ']' 
;

oExpr:		getExpr | function | otherOp | condition
;


int:		tINT { $$ = $1; }
		|	intOp { $$ = $1; }
;

float:		tFLOAT { $$ = $1; }
		|	floatOp { $$ = $1; }
;

str: 		tSTRING { $$ = $1; }
		|	stringOp { $$ = $1; }	
;

function:	 '[' tFUNCTION ',' '[' parametersList ']' ',' '[' stmtlst ']' ']'
		| '[' tFUNCTION ',' '[' ']' ',' '[' stmtlst ']' ']'
;

condition:	'[' tEQUALITY ',' expr ',' expr ']'
		| '[' tGT ',' expr ',' expr ']'
		| '[' tLT ',' expr ',' expr ']'
		| '[' tGEQ ',' expr ',' expr ']'
		| '[' tLEQ ',' expr ',' expr ']'
;

returnStmt:	'[' tRETURN ',' expr ']'
		| '[' tRETURN ']'
;

parametersList: parametersList ',' tIDENT | tIDENT
;

exprList:	exprList ',' expr | expr
;

%%

char *substring(char *string, int position, int length)
{
   char *p;
   int c;
 
   p = malloc(length+1);
   
   if (p == NULL)
   {
      printf("Unable to allocate memory.\n");
      exit(1);
   }
 
   for (c = 0; c < length; c++)
   {
      *(p+c) = *(string+position-1);      
      string++;  
   }
 
   *(p+c) = '\0';
 
   return p;
}


int main ()
{
	if (yyparse()) {
		// parse error
		printf("ERROR\n");
		return 1;
	}
	else
	{
		// successful parsing
		// printf("OK\n");

		return 0;
	}
}
