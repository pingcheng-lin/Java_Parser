%{
#include "y.tab.h" // Remember to includ this header file
#include <stdio.h>
#include <string.h>
int charCount = 1, lineCount = 1;
int start = 1;
%}
space [ ]
tab \t
eol \n
carriage \r
symbol [\,\:\;\(\)\[\]\{\}]

addition \+
increment \+\+
subtraction \-
decrement \-\-
mutiplication \*
division \/
modulus \%
assignment \=
less \<
less_or_equal \<\=
greater_or_equal \>\=
greater \>
equal \=\=
not_equal \!\=
logical_and \&\&
logical_or \|\|
logical_not \!
operator  {addition}|{increment}|{subtraction}|{decrement}|{mutiplication}|{division}|{modulus}|{assignment}|{less}|{less_or_equal}|{greater_or_equal}|{greater}|{equal}|{not_equal}|{logical_and}|{logical_or}|{logical_not}
reserved_word boolean|break|byte|case|char|catch|class|const|continue|default|do|double|else|extends|false|final|finally|float|for|if|implements|int|long|main|new|print|private|protected|public|return|short|static|string|switch|this|true|try|void|while
float \-?[0-9]+[.eE][0-9]*[eE]?[\-\+]?[0-9]*
integer \-?[0-9]+
comment (\/\/)[^\n\r]*|"/*"([^*]|\*+[^*/])*\*+"/"
string \"(\\.|[^"\\])*\"
id [A-Za-z_\$][A-Za-z0-9_\$]*
error_id [0-9\^#][A-Za-z0-9_\$]+
%%
{space} {
    if(start == 1 && charCount == 1)
        printf("Line %d : ", lineCount++);
    printf(" ");
    charCount++;
}
{tab} {
    if(start == 1 && charCount == 1)
        printf("Line %d : ", lineCount++);
    printf("    ");
    charCount += 4;
}
{eol} {
    printf("\nLine %d : ", lineCount++);
    start = 0;
	charCount = 1;
}
{carriage} {
}
{symbol} {
    if(start == 1 && charCount == 1)
        printf("Line %d : ", lineCount++);
	printf("%s", yytext);
	charCount += yyleng;
    if(!strcmp(yytext, ",")) return COMMA;
    else if(!strcmp(yytext, ":")) return COLON;
    else if(!strcmp(yytext, ";")) return SEMICOLON;
    else if(!strcmp(yytext, "(")) return LP;
    else if(!strcmp(yytext, ")")) return RP;
    else if(!strcmp(yytext, "[")) return LS;
    else if(!strcmp(yytext, "]")) return RS;
    else if(!strcmp(yytext, "{")) return LC;
    else if(!strcmp(yytext, "}")) return RC;
}
{operator} {
    if(start == 1 && charCount == 1)
        printf("Line %d : ", lineCount++);
	printf("%s", yytext);
	charCount += yyleng;
    if(!strcmp(yytext, "+")) return ADDITION;
    else if(!strcmp(yytext, "++")) return INCREMENT;
    else if(!strcmp(yytext, "-")) return SUBTRACTION;
    else if(!strcmp(yytext, "--")) return DECREMENT;
    else if(!strcmp(yytext, "*")) return MULTIPLICATION;
    else if(!strcmp(yytext, "/")) return DIVISION;
    else if(!strcmp(yytext, "%")) return MODULUS;
    else if(!strcmp(yytext, "=")) return ASSIGN;
    else if(!strcmp(yytext, "<")) return LESS;
    else if(!strcmp(yytext, "<=")) return LESS_EQUAL;
    else if(!strcmp(yytext, ">=")) return GREATER_EQUAL;
    else if(!strcmp(yytext, ">")) return GREATER;
    else if(!strcmp(yytext, "==")) return EQUAL;
    else if(!strcmp(yytext, "!=")) return NOT_EQUAL;
    else if(!strcmp(yytext, "&&")) return L_AND;
    else if(!strcmp(yytext, "||")) return L_OR;
    else if(!strcmp(yytext, "!")) return L_NOT;
}
{reserved_word} {
    if(start == 1 && charCount == 1)
        printf("Line %d : ", lineCount++);
	printf("%s", yytext);
	charCount += yyleng;
    if(!strcmp(yytext, "boolean")) return BOOLEAN;
    else if(!strcmp(yytext, "break")) return BREAK;
    else if(!strcmp(yytext, "byte")) return BYTE;
    else if(!strcmp(yytext, "case")) return CASE;
    else if(!strcmp(yytext, "char")) return CHAR;
    else if(!strcmp(yytext, "catch")) return CATCH;
    else if(!strcmp(yytext, "class")) return CLASS;
    else if(!strcmp(yytext, "const")) return CONST;
    else if(!strcmp(yytext, "continue")) return CONTINUE;
    else if(!strcmp(yytext, "default")) return DEFAULT;
    else if(!strcmp(yytext, "do")) return DO;
    else if(!strcmp(yytext, "double")) return DOUBLE;
    else if(!strcmp(yytext, "else")) return ELSE;
    else if(!strcmp(yytext, "extends")) return EXTENDS;
    else if(!strcmp(yytext, "false")) return FALSE;
    else if(!strcmp(yytext, "final")) return FINAL;
    else if(!strcmp(yytext, "finally")) return FINALLY;
    else if(!strcmp(yytext, "float")) return FLOAT;
    else if(!strcmp(yytext, "for")) return FOR;
    else if(!strcmp(yytext, "if")) return IF;
    else if(!strcmp(yytext, "implements")) return IMPLEMENTS;
    else if(!strcmp(yytext, "int")) return INT;
    else if(!strcmp(yytext, "long")) return LONG;
    else if(!strcmp(yytext, "main")) return MAIN;
    else if(!strcmp(yytext, "new")) return NEW;
    else if(!strcmp(yytext, "print")) return PRINT;
    else if(!strcmp(yytext, "private")) return PRIVATE;
    else if(!strcmp(yytext, "protected")) return PROTECTED;
    else if(!strcmp(yytext, "public")) return PUBLIC;
    else if(!strcmp(yytext, "return")) return RETURN;
    else if(!strcmp(yytext, "short")) return SHORT;
    else if(!strcmp(yytext, "static")) return STATIC;
    else if(!strcmp(yytext, "string")) return STRING;
    else if(!strcmp(yytext, "switch")) return SWITCH;
    else if(!strcmp(yytext, "this")) return THIS;
    else if(!strcmp(yytext, "true")) return TRUE;
    else if(!strcmp(yytext, "try")) return TRY;
    else if(!strcmp(yytext, "void")) return VOID;
    else if(!strcmp(yytext, "while")) return WHILE;
}
{float} {
    if(start == 1 && charCount == 1)
        printf("Line %d : ", lineCount++);
	printf("%s", yytext);
	charCount += yyleng;
	return NUM_FLOAT;
}
{integer} {
    if(start == 1 && charCount == 1)
        printf("Line %d : ", lineCount++);
	printf("%s", yytext);
	charCount += yyleng;
	return NUM_INTEGER;
}
{comment} {
    if((start == 1 && charCount == 1))
        printf("Line %d : ", lineCount++);
	for(int i = 0; i < yyleng; i++) {
        printf("%c", yytext[i]);
		if(yytext[i] == '\n') {
            printf("Line %d : ", lineCount++);
            charCount=1;
        }
        else
            charCount++;
    }
}
{string} {
	char* temp = (char*)malloc(yyleng);
	char* dst = temp;
	for(int i = 0; i < yyleng; i++) {
		if(yytext[i] == '\\')
			continue;
		*temp = yytext[i];
		temp++;
	}
	*temp = '\0';
    if(start == 1 && charCount == 1)
        printf("Line %d : ", lineCount++);
	printf("%s", dst);
	return VAR_STRING;
}
{id} {
    if(start == 1 && charCount == 1)
        printf("Line %d : ", lineCount++);
	printf("%s", yytext);
	charCount += yyleng;
    yylval.the_id = strdup(yytext);
	return ID;
}
{error_id} {
	if(start == 1 && charCount == 1)
        printf("Line %d : ", lineCount++);
	printf("%s", yytext);
	charCount += yyleng;
}
. {
    if(start == 1 && charCount == 1)
        printf("Line %d : ", lineCount++);
	printf("%s", yytext);
	charCount += yyleng;
}
%%
