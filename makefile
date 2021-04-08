FILE_lex=	B073040030.l
PROG_lex=	lex.yy.c
all:	$(PROG_lex)
	gcc $(PROG_lex) -o demo -lfl

$(PROG_lex):	$(FILE_lex)
	flex $(FILE_lex)

clean:
	rm demo $(PROG_lex)
