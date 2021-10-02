%{
    #include <stdio.h>
    #include <string.h>
    #include <math.h>
    extern int charCount, lineCount;
    int yylex();
    void yyerror();
    int lookup(char* s);
    int insert(char* s);
    char msg[256];
    char temp[256];
    int flag = 1;
    int current_curly = 0, total_curly = 0;
    char *table[50][50];
    int idCount[50] = {0};
    int check_duplicate = 0, index_duplicate = 0;
    int temp_charCount = 0;
    extern char *yytext;
    char *temp_yytext;
    int wrong = 0;
    int check_if = -1;
%}
%union {
    char* the_id;
}
%token <the_id> ID
%token COMMA COLON SEMICOLON LP RP LS RS LC RC
%token ADDITION INCREMENT SUBTRACTION DECREMENT MULTIPLICATION DIVISION MODULUS ASSIGN LESS LESS_EQUAL GREATER_EQUAL GREATER EQUAL NOT_EQUAL L_AND L_OR L_NOT
%token BOOLEAN BREAK BYTE CASE CHAR CATCH CLASS CONST CONTINUE DEFAULT DO DOUBLE ELSE EXTENDS FALSE FINAL FINALLY FLOAT FOR IF IMPLEMENTS INT LONG MAIN NEW PRINT PRIVATE PROTECTED PUBLIC RETURN SHORT STATIC STRING SWITCH THIS TRUE TRY VOID WHILE
%token NUM_FLOAT NUM_INTEGER COMMENT VAR_STRING
%%
//在lex印出text，在yacc印出error
//此處處理所有的狀況，抓到錯誤的話wrong=1，直到抓到下個正確的token，才會印出error
check: 
    | check declaration { //會看重複id的flag是不是true
            if(wrong == 1) yyerror();
            if(check_duplicate) {
                printf("\n> '%s' is a duplicate identifier.", table[current_curly][index_duplicate]);
                check_duplicate = 0;
            }
        }
    | check class { //會看重複id的flag是不是true
            if(wrong == 1) yyerror();
            if(check_duplicate) {
                printf("\n> '%s' is a duplicate identifier.", table[current_curly][index_duplicate]);
                check_duplicate = 0;
            }
        }
    | check object {if(wrong == 1) yyerror();}
    | check main {if(wrong == 1) yyerror();}
    | check left_curly {if(wrong == 1) yyerror();}
    | check right_curly {if(wrong == 1) yyerror();}
    | check simple {if(wrong == 1) yyerror();}
    | check loop {if(wrong == 1) yyerror();}
    | check return {if(wrong == 1) yyerror();}
    | check method {if(wrong == 1) yyerror();}
    | check SEMICOLON {if(wrong == 1) yyerror();}
    | check conditional {if(wrong == 1) yyerror();}
    | check ELSE { //會判斷他的上面有沒有if，且在同一層scope裡
            if(wrong == 1) yyerror();
            if(check_if != current_curly && wrong == 0) {
                wrong = 1;
                temp_charCount = charCount;
                temp_yytext = strdup("else");
                yyerror();
            }
        }
    | error {
            if(wrong == 0) {
                temp_yytext = strdup(yytext);
                temp_charCount = charCount;
                wrong = 1;
            }
        }
    ;

//此處處理宣告的部份，會把告的id放入id table裡
declaration: STATIC type identifier_list SEMICOLON 
    | type identifier_list SEMICOLON
    | type LS RS declare_id ASSIGN NEW type LS NUM_INTEGER RS SEMICOLON
    | FINAL type identifier_list SEMICOLON 
    ;
type: BOOLEAN | CHAR | DOUBLE | FLOAT | INT | LONG | SHORT | STRING | VOID;
identifier_list: declare_id
    | declare_id ASSIGN expression
    | identifier_list COMMA declare_id
    | identifier_list COMMA declare_id ASSIGN expression
    ;
const_expr: NUM_FLOAT | NUM_INTEGER | VAR_STRING;
declare_id: ID {insert($1);};

//此處處理class，也會把拿到的class id放入id table裡
class: CLASS ID { 
        insert($2);
    };
object: ID ID ASSIGN NEW ID LP RP SEMICOLON;

//此處處理main部份
main: MAIN LP RP | type main; 

//此處處理scope，遇到{，就視為下一層scope
left_curly: LC { 
        if(current_curly == 0)
                current_curly = ++total_curly;
        else {
            current_curly++;
            total_curly++;
        }
    };
//此處處理scope，遇到}，就移回上一層scope
right_curly: RC {current_curly--;}; 

//此處處理simple，照著規格書上列出
simple: ID ASSIGN expression SEMICOLON 
    | PRINT LP expression RP SEMICOLON
    | ID INCREMENT SEMICOLON
    | ID DECREMENT SEMICOLON
    | expression SEMICOLON
    ;
expression: term
    | expression ADDITION term
    | expression SUBTRACTION term
    ;
term: factor | term MULTIPLICATION factor | term DIVISION factor;
factor: ID | const_expr | LP expression RP | prefixop ID
    | method_invoke | ID LS NUM_INTEGER RS | LS NUM_INTEGER RS
    | ID LS NUM_INTEGER RS INCREMENT | ID LS NUM_INTEGER RS DECREMENT;
prefixop: INCREMENT | DECREMENT | ADDITION | SUBTRACTION;
method_invoke: ID LP method_invoke_content RP;
method_invoke_content: expression | method_invoke_content COMMA expression;

//此處處理loop，照著規格書上列出
loop: WHILE LP boolean_expr RP 
    | FOR LP forinitopt SEMICOLON boolean_expr SEMICOLON forupdateopt RP
    ;
boolean_expr: expression infixop expression;
infixop: EQUAL | NOT_EQUAL | LESS | GREATER | LESS_EQUAL | GREATER_EQUAL;
forinitopt: INT ID ASSIGN expression
    | ID ASSIGN expression
    | ID LS NUM_INTEGER RS ASSIGN expression
    | forinitopt COMMA ID ASSIGN expression
    ;
forupdateopt: ID INCREMENT | ID DECREMENT | ID LS NUM_INTEGER RS INCREMENT | ID LS NUM_INTEGER RS DECREMENT;

//此處處理return
return: RETURN expression SEMICOLON; 

//此處處理method，照著規格書上列出
method: type ID LP formal_argument RP | method_modifier type ID LP formal_argument RP;
method_modifier: PUBLIC | PROTECTED | PRIVATE;
formal_argument: | type ID | formal_argument COMMA type ID;

//此處處理conditional，照著規格書上列出
conditional: IF LP boolean_expr RP {check_if = current_curly;}; 
%%

int main(){
    yyparse();
    printf("\n");
    return 0;
}

void yyerror() {
    if(wrong == 1) {
	    printf("\nLine %d, 1st char: %d, a syntax error at \"%s\"", lineCount-1, temp_charCount, temp_yytext);
        wrong = 0;
        return;
    }
}
int lookup(char* s) { //檢查重複
	for(int i = 0; i < idCount[current_curly]; i++) {
		if(!strcmp(s, table[current_curly][i])) {
            check_duplicate = 1;
            index_duplicate = i;
            return i;
        }
    }
	return -1;
}
int insert(char* s) { //沒重複就插入table
	int flag = lookup(s);
	if(flag == -1) {
        table[current_curly][idCount[current_curly]] = strdup(s);
		idCount[current_curly]++;
		return idCount[current_curly]-1;
	}
	else
		return flag;
}
