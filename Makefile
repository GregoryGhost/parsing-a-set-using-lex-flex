# Makefile using Lex to build

CC     = g++
CFLAGS = -c

LEX    = lex
LFLAGS =

LN     = g++
LNFLAGS=

SRC    = calc.l 
OBJ    = calc.o 

all:	calc

#test: all
#	./calc < test1.txt

calc:	$(OBJ)
	$(LN) $(LNFLAGS) -o calc.out $(OBJ)

calc.o:	calc.c
	$(CC) $(CFLAGS) -o calc.o calc.c

calc.c: calc.l
	$(LEX) $(LFLAGS) -o calc.c calc.l

clean:
	rm -f calc.out calc.c *.o
