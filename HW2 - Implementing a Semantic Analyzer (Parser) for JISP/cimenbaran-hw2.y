%{
#include <stdio.h>

void yyerror(char* msg) 
{

}


%}
%token tSTRING tNUM tPRINT tGET tSET tFUNCTION tRETURN tIDENT tEQUALITY tIF tGT tLT tGEQ tLEQ tINC tDEC tPLUS tMINUS tMULTIPLY tDIVIDE
%start program

%%

program : '[' statementList ']'
	| '[' ']'
;
 
statementList : statementList statement
	| statement
;

statement : '[' ifStatement ']'
	|   '[' setStatement ']'
	|   '[' printStatement ']'
	|   '[' incrementStatement ']'
	|   '[' decrementStatement ']'
	|   '[' returnStatement ']'
	|    expression 
;

returnStatement : return ',' expression
	| return 
;

setStatement : set ',' ident ',' expression
;

ifStatement :  if ',' condition ',' '[' statementList ']' '[' statementList ']'
	| if ',' condition ',' '[' statementList ']'
	| if ',' condition ',' '[' ']'
	| if ',' condition ',' '[' ']' '[' ']'
	| if ',' condition ',' '[' ']' '[' statementList ']'
	| if ',' condition ',' '[' statementList ']' '[' ']'
;

printStatement : print ',' '[' expression ']'
;

incrementStatement : increment ',' ident
;

decrementStatement : decrement ',' ident
;

functionStatement : function ',' '[' funcParams ']' ',' '[' statementList ']'
	| function ',' '[' funcParams ']' ',' '[' ']'
	| function ',' '[' ']' ',' '[' statementList ']'
	| function ',' '[' ']' ',' '[' ']'
;

funcParams : funcParams ',' ident
	| ident
;

condition : '[' tGEQ ',' expression ',' expression ']'
	| '[' tLEQ ',' expression ',' expression ']'
	| '[' tGT ',' expression ',' expression ']'
	| '[' tLT ',' expression ',' expression ']'
	| '[' tEQUALITY ',' expression ',' expression ']'
;

expression : number
	| string
	| '[' functionStatement ']'
	| getExpression
	| condition
	| operatorApplication
;

operatorApplication : '[' operator ',' expression ',' expression ']'
;

operator : tPLUS
	| tMINUS
	| tMULTIPLY
	| tDIVIDE
;

getExpression : '[' get ',' ident ',' '[' params ']' ']'
	|  '[' get ',' ident ',' '[' ']' ']'
	| '[' get ',' ident ']'
;

params : params ',' expression
	| expression
;

return : tRETURN
;

get : tGET
;

increment : tINC
;

decrement : tDEC
;

function : tFUNCTION
;

if : tIF
;

print : tPRINT
;

set : tSET
;

number : tNUM
;

string : tSTRING
;

ident : tIDENT
;


%%
int main()
{
	if(yyparse()) 
	{
		// parse error
		printf("ERROR\n");
		return 1;
	}
	else 
	{
		// successful parsing
		printf("OK\n");
		return 0;
	}
	
}
