PG = main
GFN = grammaire.y
RFN = analysev2.lex
SRCC:= ./src/*.c
INTER = interpreter


OBJ=y.tab.o lex.yy.o main.o

default: compiler

compiler: ./src/$(INTER).y ./src/$(GFN) ./src/$(RFN) ./src/$(INTER).l ./src/instructions.c libraries
	yacc -d src/$(GFN)
	yacc src/$(GFN)
	flex src/$(RFN)
	gcc y.tab.c symbol_table.o util.o memory_z.o lex.yy.c -o $(PG)
	yacc -d ./src/$(INTER).y
	lex ./src/$(INTER).l
	gcc lex.yy.c y.tab.c ./src/instructions.c -Isrc -o $(INTER)


libraries: ./src/symbol_table.c ./src/opTable.c ./src/memory_z.c ./src/util.c
	gcc -c src/symbol_table.c 
	gcc -c src/opTable.c
	gcc -c src/memory_z.c
	gcc -c src/util.c

clean:
	rm $(OBJ) y.tab.c y.tab.h lex.yy.c

run: 
	./$(PG) < example.c
	./$(INTER) < test-asm.txt
	

