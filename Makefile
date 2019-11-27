CC = gcc
LEX = flex
CFLAGS = -Wall -std=c99
CXXFLAGS = -Wall -std=c++11
NOWARN = -Wno-unused -Wno-sign-compare

LFLAGS = #-d

OBJS = lex.yy.o main.o
EXE = scanner

run: $(OBJS)
	$(CC) $(CFLAGS) -o $(EXE) $(OBJS)

lex.yy.c: verilog_scanner.l verilog_parser.tab.h
	$(LEX) $(LFLAGS) verilog_scanner.l

lex.yy.o: lex.yy.c
	$(CC) $(CFLAGS) $(NOWARN) -c lex.yy.c

clean:
	$(RM) $(EXE) $(OBJS)
	$(RM) *.tab.c lex.yy.c
	$(RM) parse.output
