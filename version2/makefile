all : 
	flex -i cal.l
	bison cal.y
	gcc cal.tab.c -o calculadora
	./calculadora