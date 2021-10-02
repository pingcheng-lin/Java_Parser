all:	clean y.tab.c lex.yy.c
	gcc lex.yy.c y.tab.c -ly -lfl -o a.out

y.tab.c:
	bison -y -d B073040030.y

lex.yy.c:
	flex B073040030.l

clean:
	rm -f a.out lex.yy.c y.tab.c y.tab.h
