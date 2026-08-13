#include <stdio.h>
#include <string.h>
#include <ctype.h>

FILE *fp;

char delim[14] = {
    ' ', '\t', '\n', ',', ';', '(', ')', '{', '}', '[', ']', '#', '<', '>'};

char oper[7] = {
    '+', '-', '*', '/', '%', '=', '!'};

char key[20][12] = {
    "int", "float", "char", "double", "bool", "void", "extern",
    "unsigned", "goto", "static", "class", "struct", "for", "if",
    "else", "return", "register", "long", "while", "do"};

char predirect[2][12] = {
    "include", "define"};

char header[6][15] = {
    "stdio.h", "conio.h", "malloc.h",
    "process.h", "string.h", "ctype.h"};

void skipcomment();
void analyze();
void check(char[]);
int isdelim(char);
int isop(char);

int fop = 0, numflag = 0, f = 0;
char c, ch, sop;


int main() {
    char fname[50];

    printf("\nEnter filename : ");
    scanf("%s", fname);

    fp = fopen(fname, "r");

    if (fp == NULL)
        printf("\nThe file doesn't exist.");
    else
        analyze();

    printf("\nEnd of file\n");

    fclose(fp);

    return 0;
}


void analyze() {
    char token[50];
    int j = 0;

    while (!feof(fp)) {
        c = getc(fp);

        if (c == '/') {
            skipcomment();
        }

        else if (c == '\"') {
            while ((c = getc(fp)) != '\"')
                ;
        }

        else if (isalpha(c)) {
            if (f == 0) {
                token[j] = '\0';
                check(token);
                numflag = 0;
                j = 0;
                f = 0;
            }

            token[j] = c;
            j++;
            f = 1;
        }

        else if (isalnum(c)) {
            token[j] = c;
            j++;
        }

        else {
            if (numflag == 0)
                numflag = 1;

            token[j] = c;
            j++;

            if (isdelim(c)) {
                token[j] = '\0';

                if (j > 1)
                    check(token);

                numflag = 0;
                j = 0;
                f = 0;

                printf("\nDelimiter\t %c", c);
            }

            else if (isop(c)) {
                token[j - 1] = '\0';

                if (strlen(token) > 0)
                    check(token);

                if (fop == 1) {
                    printf("\nOperator\t %c%c", c, sop);
                    fop = 0;
                } else {
                    printf("\nOperator\t %c", c);
                }

                j = 0;
                f = 0;
                numflag = 0;
            }

            else if (c == '.') {
                token[j] = c;
                j++;
            }
        }
    }
}


int isdelim(char c) {
    int i;

    for (i = 0; i < 14; i++) {
        if (c == delim[i])
            return 1;
    }

    return 0;
}


int isop(char c) {
    int i, j;
    char temp;

    for (i = 0; i < 7; i++) {
        if (c == oper[i]) {
            temp = getc(fp);

            for (j = 0; j < 7; j++) {
                if (temp == oper[j]) {
                    fop = 1;
                    sop = temp;
                    return 1;
                }
            }

            ungetc(temp, fp);
            return 1;
        }
    }

    return 0;
}


void check(char t[]) {
    int i;

    if (numflag == 1) {
        printf("\nNumber\t\t %s", t);
        return;
    }


    for (i = 0; i < 2; i++) {
        if (strcmp(t, predirect[i]) == 0) {
            printf("\nPreprocessor directive\t%s", t);
            return;
        }
    }


    for (i = 0; i < 6; i++) {
        if (strcmp(t, header[i]) == 0) {
            printf("\nHeader file\t%s", t);
            return;
        }
    }


    for (i = 0; i < 20; i++) {
        if (strcmp(key[i], t) == 0) {
            printf("\nKeyword\t\t%s", key[i]);
            return;
        }
    }


    printf("\nIdentifier\t%s", t);
}


void skipcomment() {
    ch = getc(fp);

    if (ch == '/') {
        while ((ch = getc(fp)) != '\n' && ch != EOF)
            ;
    }

    else if (ch == '*') {
        while (1) {
            ch = getc(fp);

            if (ch == '*') {
                c = getc(fp);

                if (c == '/')
                    break;
            }
        }
    }

    else {
        ungetc(ch, fp);
    }
}