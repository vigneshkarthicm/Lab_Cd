%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

/* Function prototypes */
int yylex(void);
int yyerror(char *s);

/* Check whether a string is an integer constant */
int isNumber(char *s)
{
    int i = 0;

    if (s == NULL || s[0] == '\0')
        return 0;

    while (s[i] != '\0')
    {
        if (!isdigit((unsigned char)s[i]))
            return 0;

        i++;
    }

    return 1;
}
%}

%union {
    char *str;
}

%token <str> ID NUM

%type <str> expr

/* Operator precedence */
%left '+' '-'
%left '*' '/'

%%

stmt_list:
    stmt_list stmt
    | stmt
    ;

stmt:
    ID '=' expr ';'
    {
        printf("%s = %s\n", $1, $3);
    }
    ;

expr:
    NUM
    {
        $$ = $1;
    }

    | ID
    {
        $$ = $1;
    }

    | expr '+' expr
    {
        if (isNumber($1) && isNumber($3))
        {
            char buf[40];

            sprintf(buf, "%d", atoi($1) + atoi($3));
            $$ = strdup(buf);

            printf("// Constant Folding: %s + %s -> %s\n",
                   $1, $3, $$);
        }
        else if (strcmp($3, "0") == 0)
        {
            $$ = $1;

            printf("// Algebraic Simplification: x + 0 -> x\n");
        }
        else if (strcmp($1, "0") == 0)
        {
            $$ = $3;

            printf("// Algebraic Simplification: 0 + x -> x\n");
        }
        else
        {
            char buf[100];

            sprintf(buf, "%s + %s", $1, $3);
            $$ = strdup(buf);
        }
    }

    | expr '-' expr
    {
        if (isNumber($1) && isNumber($3))
        {
            char buf[40];

            sprintf(buf, "%d", atoi($1) - atoi($3));
            $$ = strdup(buf);

            printf("// Constant Folding: %s - %s -> %s\n",
                   $1, $3, $$);
        }
        else if (strcmp($3, "0") == 0)
        {
            $$ = $1;

            printf("// Algebraic Simplification: x - 0 -> x\n");
        }
        else
        {
            char buf[100];

            sprintf(buf, "%s - %s", $1, $3);
            $$ = strdup(buf);
        }
    }

    | expr '*' expr
    {
        if (isNumber($1) && isNumber($3))
        {
            char buf[40];

            sprintf(buf, "%d", atoi($1) * atoi($3));
            $$ = strdup(buf);

            printf("// Constant Folding: %s * %s -> %s\n",
                   $1, $3, $$);
        }
        else if (strcmp($3, "1") == 0)
        {
            $$ = $1;

            printf("// Algebraic Simplification: x * 1 -> x\n");
        }
        else if (strcmp($1, "1") == 0)
        {
            $$ = $3;

            printf("// Algebraic Simplification: 1 * x -> x\n");
        }
        else if (strcmp($3, "2") == 0)
        {
            char buf[100];

            sprintf(buf, "%s + %s", $1, $1);
            $$ = strdup(buf);

            printf("// Strength Reduction: x * 2 -> x + x\n");
        }
        else
        {
            char buf[100];

            sprintf(buf, "%s * %s", $1, $3);
            $$ = strdup(buf);
        }
    }

    | expr '/' expr
    {
        if (isNumber($1) && isNumber($3))
        {
            int divisor = atoi($3);

            if (divisor == 0)
            {
                printf("// Error: Division by zero\n");

                char buf[100];
                sprintf(buf, "%s / %s", $1, $3);
                $$ = strdup(buf);
            }
            else
            {
                char buf[40];

                sprintf(buf, "%d", atoi($1) / divisor);
                $$ = strdup(buf);

                printf("// Constant Folding: %s / %s -> %s\n",
                       $1, $3, $$);
            }
        }
        else if (strcmp($3, "1") == 0)
        {
            $$ = $1;

            printf("// Algebraic Simplification: x / 1 -> x\n");
        }
        else
        {
            char buf[100];

            sprintf(buf, "%s / %s", $1, $3);
            $$ = strdup(buf);
        }
    }
    ;

%%

int main()
{
    printf("Enter Three Address Code statements (end with Ctrl+D):\n");

    yyparse();

    return 0;
}

int yyerror(char *s)
{
    printf("Syntax Error: %s\n", s);

    return 0;
}