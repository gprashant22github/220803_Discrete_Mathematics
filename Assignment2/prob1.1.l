%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// Token types
#define KEYWORD 1
#define OPERATOR 2
#define IDENTIFIER 3
#define STRING 4
#define DELIMITER 5
#define INTEGER 6
#define FLOATING_POINT 7
#define HEXADECIMAL 8

int line_number = 1;

typedef struct Token {
    char *lexeme;
    int type;
    int count;
    struct Token *next;
} Token;

Token *token_list = NULL;

void yyerror(const char *msg);
void add_token(char *lexeme, int type);
void print_tokens();
void free_tokens();
void convert_to_lowercase(char *str);

%}

%option noyywrap

%%

[\t\f ]+                    { /* Ignore whitespace */ }
\n                          { line_number++; }
[Aa][Rr][Rr][Aa][Yy]        { add_token("ARRAY", KEYWORD); }
[Bb][Ee][Gg][Ii][Nn]        { add_token("BEGIN", KEYWORD); }
[Bb][Oo][Oo][Ll][Ee][Aa][Nn] { add_token("BOOLEAN", KEYWORD); }
[Cc][Oo][Mm][Mm][Ee][Nn][Tt] { add_token("COMMENT", KEYWORD); }
[Cc][Oo][Nn][Tt][Ii][Nn][Uu][Ee] { add_token("CONTINUE", KEYWORD); }
[Dd][Oo]                    { add_token("DO", KEYWORD); }
[Dd][Oo][Uu][Bb][Ll][Ee]    { add_token("DOUBLE", KEYWORD); }
[Ee][Ll][Ss][Ee]            { add_token("ELSE", KEYWORD); }
[Ee][Nn][Dd]                { add_token("END", KEYWORD); }
[Ff][Aa][Ll][Ss][Ee]        { add_token("FALSE", KEYWORD); }
[Ff][Oo][Rr]                { add_token("FOR", KEYWORD); }
[Ii][Ff]                    { add_token("IF", KEYWORD); }
[Ii][Nn][Tt][Ee][Gg][Ee][Rr] { add_token("INTEGER", KEYWORD); }
[Ll][Aa][Bb][Ee][Ll]        { add_token("LABEL", KEYWORD); }
[Ll][Ii][Ss][Tt]            { add_token("LIST", KEYWORD); }
[Ll][Oo][Nn][Gg]            { add_token("LONG", KEYWORD); }
[Oo][Ww][Nn]                { add_token("OWN", KEYWORD); }
[Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee] { add_token("PROCEDURE", KEYWORD); }
[Ss][Tt][Ee][Pp]            { add_token("STEP", KEYWORD); }
[Ss][Ww][Ii][Tt][Cc][Hh]    { add_token("SWITCH", KEYWORD); }
[Tt][Hh][Ee][Nn]            { add_token("THEN", KEYWORD); }
[Tt][Rr][Uu][Ee]            { add_token("TRUE", KEYWORD); }
[Uu][Nn][Tt][Ii][Ll]        { add_token("UNTIL", KEYWORD); }
[Vv][Aa][Ll][Uu][Ee]        { add_token("VALUE", KEYWORD); }
[Ww][Hh][Ii][Ll][Ee]        { add_token("WHILE", KEYWORD); }
[Aa][Nn][Dd]                { add_token("AND", OPERATOR); }
[Oo][Rr]                    { add_token("OR", OPERATOR); }
[Ll][Ee][Qq]                { add_token("LEQ", OPERATOR); }
[Ll][Tt]                    { add_token("LT", OPERATOR); }
[Gg][Ee][Qq]                { add_token("GEQ", OPERATOR); }
[Gg][Tt]                    { add_token("GT", OPERATOR); }
[Nn][Oo][Tt]                { add_token("NOT", OPERATOR); }
[Ee][Qq][Ll]                { add_token("EQL", OPERATOR); }
[Nn][Ee][Qq]                { add_token("NEQ", OPERATOR); }
"%"|"&"|"<="|"+"|"-"|"/"|">="|":="|"*"|"^"|"|"|"<<"|">>" { add_token(yytext, OPERATOR); }
"("|")"|"["|"]"|"{"|"}"|","|"'"|";"|"\""|":"|"'" { add_token(yytext, DELIMITER); }
[a-zA-Z][a-zA-Z0-9]*        { add_token(yytext, IDENTIFIER); }
\"([^\"\n]*)\"              { add_token(yytext, STRING); }
\'([^\'\n]*)\'              { add_token(yytext, STRING); }
0[xX][0-9a-fA-F]+           { add_token(yytext, HEXADECIMAL); }
[0-9]+\.[0-9]{1,6}          { add_token(yytext, FLOATING_POINT); }
[0-9]+                      { add_token(yytext, INTEGER); }
.                           { yyerror("Illegal character"); }

%%

void yyerror(const char *msg) {
    fprintf(stderr, "Error: %s at line %d\n", msg, line_number);
    print_tokens();
    free_tokens();
    exit(1);
}

void add_token(char *lexeme, int type) {
    Token *current = token_list;
    while (current != NULL) {
        if (strcmp(current->lexeme, lexeme) == 0 && current->type == type) {
            current->count++;
            return;
        }
        current = current->next;
    }
    Token *new_token = (Token *)malloc(sizeof(Token));
    new_token->lexeme = strdup(lexeme);
    new_token->type = type;
    new_token->count = 1;
    new_token->next = token_list;
    token_list = new_token;
}

int compare_tokens(const void *a, const void *b) {
    Token *tokenA = *(Token **)a;
    Token *tokenB = *(Token **)b;
    return strcmp(tokenA->lexeme, tokenB->lexeme);
}

void print_tokens() {
    int token_count = 0;
    Token *current = token_list;
    while (current != NULL) {
        token_count++;
        current = current->next;
    }

    Token **tokens = (Token **)malloc(token_count * sizeof(Token *));
    current = token_list;
    for (int i = 0; i < token_count; i++) {
        tokens[i] = current;
        current = current->next;
    }

    qsort(tokens, token_count, sizeof(Token *), compare_tokens);

    printf("LEXEME\tTOKEN\tCOUNT\n");
    for (int i = 0; i < token_count; i++) {
        printf("%s\t", tokens[i]->lexeme);
        switch (tokens[i]->type) {
            case KEYWORD: printf("KEYWORD\t"); break;
            case OPERATOR: printf("OPERATOR\t"); break;
            case IDENTIFIER: printf("IDENTIFIER\t"); break;
            case STRING: printf("STRING\t"); break;
            case DELIMITER: printf("DELIMITER\t"); break;
            case INTEGER: printf("INTEGER\t"); break;
            case FLOATING_POINT: printf("FLOATING_POINT\t"); break;
            case HEXADECIMAL: printf("HEXADECIMAL\t"); break;
        }
        printf("%d\n", tokens[i]->count);
    }

    free(tokens);
}

void free_tokens() {
    Token *current = token_list;
    while (current != NULL) {
        Token *next = current->next;
        free(current->lexeme);
        free(current);
        current = next;
    }
    token_list = NULL;
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Could not open file %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }

    yylex();
    print_tokens();
    free_tokens();
    return 0;
}
