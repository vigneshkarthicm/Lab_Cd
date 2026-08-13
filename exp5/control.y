%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
int yyerror(const char *s);
%}

%token IF ELSE FOR WHILE SWITCH CASE DEFAULT
%token ID NUM
%token LBRACE RBRACE LPAREN RPAREN COLON SEMICOLON
%token EQ LE GE LT GT ASSIGN

%start program

%%

program
    : stmt_list
    ;

stmt_list
    : stmt_list stmt
    | stmt
    ;

stmt
    : if_stmt
    | while_stmt
    | for_stmt
    | switch_stmt
    | simple_stmt
    | block
    ;

block
    : LBRACE stmt_list RBRACE
    ;

simple_stmt
    : ID ASSIGN NUM SEMICOLON
    ;

if_stmt
    : IF LPAREN cond RPAREN stmt
    | IF LPAREN cond RPAREN stmt ELSE stmt
    ;

while_stmt
    : WHILE LPAREN cond RPAREN stmt
    ;

for_stmt
    : FOR LPAREN
      ID ASSIGN NUM SEMICOLON
      cond SEMICOLON
      ID ASSIGN ID
      RPAREN
      stmt
    ;

switch_stmt
    : SWITCH LPAREN ID RPAREN LBRACE case_list RBRACE
    ;

case_list
    : case_list case_stmt
    | case_stmt
    ;

case_stmt
    : CASE NUM COLON stmt
    | DEFAULT COLON stmt
    ;

cond
    : ID relop NUM
    ;

relop
    : EQ
    | LE
    | GE
    | LT
    | GT
    ;

%%

int main(void)
{
    printf("Enter a C control structure:\n");

    if (yyparse() == 0)
        printf("Valid control structure syntax.\n");

    return 0;
}

int yyerror(const char *s)
{
    printf("Error: %s\n", s);
    return 0;
}