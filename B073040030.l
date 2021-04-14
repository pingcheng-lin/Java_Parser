%{
#include <stdio.h>
#include <string.h>
unsigned charCount = 1, idCount = 0, lineCount = 1;
#define MAX_TABLE_NUM 100
int count_symbol = 0;
char **table;
void create();
int lookup(char* s);
int insert(char* s);
void dump();
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
comment (\/\/)[^\n\r]*|\/\*(.|\n)*?\*\/
string \"(\\\"|[^\\\"])*\"
error_string (\'(\\\"|[^\\\"])*\')|(\"([^\"]|[\\])*\")|(\"[^ \n]*?)
id [A-Za-z_\$][A-Za-z0-9_\$]*
error_id [0-9\^#][A-Za-z0-9_\$]+
%%
{space} {
	charCount++;
}
{tab} {
	charCount += 4;
}
{eol} {
	lineCount++;
	charCount = 1;
}
{carriage} {
}
{symbol} {
	printf("Line: %d, 1st char: %d, \"%s\" is an \"symbol\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{operator} {
	printf("Line: %d, 1st char: %d, \"%s\" is an \"operator\".\n", lineCount, charCount, yytext);
	charCount += yyleng; 
}
{reserved_word} {
	printf("Line: %d, 1st char: %d, \"%s\" is an \"reserved_word\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{float} {
	printf("Line: %d, 1st char: %d, \"%s\" is an \"float\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{integer} {
	printf("Line: %d, 1st char: %d, \"%s\" is an \"integer\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{comment} {
	printf("Line: %d, 1st char: %d, \"%s\" is an \"comment\".\n", lineCount, charCount, yytext);
	for(int i = 0; i < yyleng; i++)
		if(yytext[i] == '\n')
			lineCount++;
	charCount += yyleng;
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
	printf("Line: %d, 1st char: %d, %s is an \"string\".\n", lineCount, charCount, dst);
	charCount += yyleng;
}
{error_string} {
	printf("Line: %d, 1st char: %d, \"%s\" is an \"INVALID STRING\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{id} {
	printf("Line: %d, 1st char: %d, \"%s\" is an \"ID\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
	insert(yytext);
}
{error_id} {
	printf("Line: %d, 1st char: %d, \"%s\" is an \"INVALID ID\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
. {
	printf("Line: %d, 1st char: %d, \"%s\" is an \"GENERAL ERROR\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
%%

int main() {
	create();
    yylex();
	dump();
    return 0;
}
void create() {
	table = (char **) malloc(MAX_TABLE_NUM*sizeof(char *));
}
int lookup(char* s) {
	for(int i = 0; i < count_symbol; i++) 
		if(strcmp(s, table[i]) == 0)
			return i;
	return -1;
}
int insert(char* s) {
	int flag = lookup(s);
	if(flag == -1) {
		table[count_symbol] = (char*) malloc(sizeof(*s));
		strcpy(table[count_symbol], s);
		count_symbol++;
		return count_symbol-1;
	}
	else
		return flag;
}
void dump() {
	printf("The symbol table contains:\n");
	for(int i = 0; i < count_symbol; i++)
		printf("%s\n", table[i]);
}