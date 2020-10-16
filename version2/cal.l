%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h> //strtof()
int linha = 1;
%}

NUMERO [0-9]+\.?[0-9]*
VARIAVEL [a-z][a-zA-Z0-9]*

/*
key words
palavras chave
*/
FIM "fim"
INICIO "inicio"
PRINT "tela"
LET "let"

%%

{INICIO} {return INICIO;}
{PRINT} {return PRINT;}
{FIM} {return FIM;}
{LET} {return LET;}
{NUMERO} {
	yylval.real = strtof(yytext, NULL);
	return NUMERO;
}
{VARIAVEL} {
	/*sscanf(*yytext, "%d", &yylval.string);*/
	yylval.string[0] = *yytext;
	return VARIAVEL;
	}
"+" {return '+';}
"-" {return '-';}
"*" {return '*';}
"/" {return '/';}
"(" {return '(';}
")" {return ')';}
"^" {return '^';}
";" {return ';';}
"=" {return '=';}

"\n"* {linha++;}

[\ \t\r\f]*	{}

. {printf("Erro lexico na linha %d\n",linha); return yytext[0];}

%%

int yywrap()
{
   return 1;
}