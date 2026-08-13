#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct table {
    char var[10];
    int value;
};

struct table tbl[20];
int i, j, n;

void create();
void modify();
int search(char variable[], int n);
void insert();
void display();

int main() {
    int ch, result = 0;
    char v[10];

    system("cls");
    do {
        printf("Enter your choice\n1.Create\n2.Insert\n3.Modify\n4.Search\n5.Display\n6.Exit:");
        scanf("%d", &ch);
        switch (ch) {
        case 1:
            create();
            break;
        case 2:
            insert();
            break;
        case 3:
            modify();
            break;
        case 4:
            printf("Enter the variable to be searched for:\n");
            scanf("%s", v);
            result = search(v, n);
            if (result == 0)
                printf("The variable does not belong to the table\n");
            else
                printf("The location of the variable is %d\nThe value of %s is %d\n", result, tbl[result].var, tbl[result].value);
            break;
        case 5:
            display();
            break;
        case 6:
            exit(0);
        }
    } while (ch != 6);

    return 0;
}

void create() {
    printf("Enter the no. of entries:");
    scanf("%d", &n);
    printf("Enter the variable and the value:\n");
    for (i = 1; i <= n; i++) {
        scanf("%s%d", tbl[i].var, &tbl[i].value);
    check:
        if (tbl[i].var[0] >= '0' && tbl[i].var[0] <= '9') {
        check1:
            printf("The variable should start with an alphabet\nEnter correct variable name:\n");
            scanf("%s%d", tbl[i].var, &tbl[i].value);
            goto check;
        }
        for (j = 1; j < i; j++) {
            if (strcmp(tbl[i].var, tbl[j].var) == 0) {
                printf("The variable already exists.Enter another variable\n");
                scanf("%s%d", tbl[i].var, &tbl[i].value);
                goto check1;
            }
        }
    }
    printf("The table after creation is:\n");
    display();
}

void insert() {
    if (n >= 20)
        printf("Cannot insert.Table is full\n");
    else {
        n++;
        printf("Enter the variable and value\n");
        scanf("%s%d", tbl[n].var, &tbl[n].value);
    check:
        if (tbl[n].var[0] >= '0' && tbl[n].var[0] <= '9') {
        check1:
            printf("The variable should start with an alphabet\nEnter correct variable name:\n");
            scanf("%s%d", tbl[n].var, &tbl[n].value);
            goto check;
        }
        for (j = 1; j < n; j++) {
            if (strcmp(tbl[j].var, tbl[n].var) == 0) {
                printf("The variable already exist.Enter another variable\n");
                scanf("%s%d", tbl[n].var, &tbl[n].value);
                goto check1;
            }
        }
        printf("The table after insertion is:\n");
        display();
    }
}

void modify() {
    char variable[10];
    int result = 0;
    printf("Enter the variable to be modified\n");
    scanf("%s", variable);
    result = search(variable, n);
    if (result == 0)
        printf("%s does not belong to table\n", variable);
    else {
        printf("The current value of the variable %s is %d\nEnter the new variable and its value\n", tbl[result].var, tbl[result].value);
        scanf("%s%d", tbl[result].var, &tbl[result].value);
    check:
        if (tbl[result].var[0] >= '0' && tbl[result].var[0] <= '9') {
            printf("The variable should start with an alphabet\nEnter correct variable name:\n");
            scanf("%s%d", tbl[result].var, &tbl[result].value);
            goto check;
        }
    }
    printf("The table after modification is:\n");
    display();
}

int search(char variable[], int n) {
    int flag = 0;
    for (i = 1; i <= n; i++) {
        if (strcmp(tbl[i].var, variable) == 0) {
            flag = 1;
            break;
        }
    }
    if (flag == 1)
        return i;
    else
        return 0;
}

void display() {
    printf("VARIABLE\t VALUE\n");
    for (i = 1; i <= n; i++)
        printf("%s\t\t%d\n", tbl[i].var, tbl[i].value);
}