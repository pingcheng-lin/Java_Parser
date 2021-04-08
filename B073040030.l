%{
#include<stdio.h>
unsigned charCount = 1, idCount = 0, lineCount = 1;
%}
space [ \t]
eol \n
carriage \r
comment (\/\/).*|\/\*(.|\n)*?\*\/
symbol [\,\:\;\(\)\[\]\{\}]

addition \+
increment \+\+
subtraction \-
decrement \-\-
mutiplication \*
division \/
modulus \%
less \<
less_or_equal \<\=
greater_or_equal \>\=
greater \>
equal \=\=
not_equal \!\=
logical_and \&\&
logical_or \|\|
logical_not \!
operator  {addition}|{increment}|{subtraction}|{decrement}|{mutiplication}|{division}|{modulus}|{less}|{less_or_equal}|{greater_or_equal}|{greater}|{equal}|{not_equal}|{logical_and}|{logical_or}|{logical_not}
reserved_word boolean|break|byte|case|char|catch|class|const|continue|default|do|double|else|extends|false|final|finally|float|for|if|implements|int|long|main|new|print|private|protected|public|return|short|static|string|switch|this|true|try|void|while
float \-?[0-9]+[.eE][0-9]*[eE]?[\-\+]?[0-9]*
integer \-?[0-9]+
id [A-Za-z_][A-Za-z0-9_]*
string \".*?[^\\]\"
%%
{space} {
	charCount++;
}
{eol} {
	lineCount++;
	charCount = 1;
}
{carriage} {
}
{comment} {
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
{string} {
	/*char* temp = malloc(strlen(yytext)+1);
	int i = 0;
	for(; i < charCount-1; i++) {
		if(yytext[i] == '\\' && yytext[i+1] == '"')
			continue;
		*temp = yytext[i];
		temp++;
	}
	*temp = yytext[i+1];
	temp++;
	*temp = '\0';*/
	printf("Line: %d, 1st char: %d, %s is an \"string\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{id} {
	printf("Line: %d, 1st char: %d, \"%s\" is an \"ID\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
. {
	printf("Line: %d, 1st char: %d, \"%s\" is an \"error\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
%%

int main() {
    yylex();
    return 0;
}
