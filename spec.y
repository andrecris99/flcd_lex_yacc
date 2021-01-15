%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YYDEBUG 1
%}

%token IDENTIFIER
%token CONSTANT
%token CHAR
%token INT
%token LIST
%token IF
%token ELSE
%token PRINT
%token READ
%token WHILE
%token MAIN
%token RETURN
%token COLON
%token SEMI_COLON
%token COMMA
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVISION
%token LESS_THAN
%token LESS_OR_EQUAL_THAN
%token ASSIGNMENT
%token GREATER_OR_EQUAL_THAN
%token GREATER_THAN
%token EQUAL
%token AND
%token OR
%token NOT
%token NOT_EQUAL
%token LEFT_SQUARE_PARENTHESIS
%token RIGHT_SQUARE_PARENTHESIS
%token LEFT_ROUND_PARENTHESIS
%token RIGHT_ROUND_PARENTHESIS
%token LEFT_ACCOLADE
%token RIGHT_ACCOLADE

%start program

%%

program : MAIN LEFT_ROUND_PARENTHESIS RIGHT_ROUND_PARENTHESIS LEFT_ACCOLADE statementList RIGHT_ACCOLADE ;
statementList : statement | statement statementList ;
statement : simpleDeclaration SEMI_COLON | simpleAssignmentStatement SEMI_COLON | listDeclaration SEMI_COLON | ioStatement SEMI_COLON | ifStatement | whileStatement ;

type : INT | CHAR ;
simpleDeclaration : type IDENTIFIER | type IDENTIFIER ASSIGNMENT expression ;
simpleAssignmentStatement : IDENTIFIER ASSIGNMENT expression ;

listDeclaration : LIST IDENTIFIER ASSIGNMENT list_of_elements ;
list_of_elements : LEFT_SQUARE_PARENTHESIS elements RIGHT_SQUARE_PARENTHESIS ;
elements : element | element COMMA elements ;
listIdentifier : IDENTIFIER LEFT_SQUARE_PARENTHESIS element RIGHT_SQUARE_PARENTHESIS ;
element : IDENTIFIER | CONSTANT ;

ioStatement : PRINT constantExpression | READ IDENTIFIER | READ listIdentifier;
ifStatement : IF LEFT_ROUND_PARENTHESIS condition RIGHT_ROUND_PARENTHESIS LEFT_ACCOLADE statementList RIGHT_ACCOLADE | IF LEFT_ROUND_PARENTHESIS condition RIGHT_ROUND_PARENTHESIS LEFT_ACCOLADE statementList RIGHT_ACCOLADE ELSE LEFT_ACCOLADE statementList RIGHT_ACCOLADE ;
whileStatement : WHILE LEFT_ROUND_PARENTHESIS condition RIGHT_ROUND_PARENTHESIS LEFT_ACCOLADE statementList RIGHT_ACCOLADE

condition : expression booleanOperator expression ;
expression : constantExpression | booleanExpression | arithmeticExpression ;
constantExpression : IDENTIFIER | CONSTANT | listIdentifier;
arithmeticExpression : expression operator expression ;
operator : PLUS | MINUS | MULTIPLY | DIVISION ;
booleanExpression : expression booleanOperator expression ;
booleanOperator : LESS_THAN | LESS_OR_EQUAL_THAN | EQUAL | NOT_EQUAL | GREATER_OR_EQUAL_THAN | GREATER_THAN | AND | OR ;


%%

yyerror(char *s)
{
  printf("%s\n", s);
}

extern FILE *yyin;

main(int argc, char **argv)
{
  if (argc > 1) 
    yyin = fopen(argv[1], "r");
  if ( (argc > 2) && ( !strcmp(argv[2], "-d") ) ) 
    yydebug = 1;
  if ( !yyparse() ) 
    fprintf(stderr,"\t Success! Syntax analysis. \n");
}