all: funcclass

funcclass: main.o funcclass.o
	g++ -g -Wall main.o FuncClass.o -o funcclass.elf

main.o: main.cpp
	g++ -g -Wall -c main.cpp

funcclass.o: FuncClass.cpp FuncClass.h
	g++ -g -Wall -c FuncClass.cpp

clean:
	rm -rf -v *.o
	rm -rf -v *.gch
