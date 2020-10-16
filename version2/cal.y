%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <conio.h>
#include <string.h> //strcmp() strcpy() strcat()
#include <stdbool.h>
 
extern int yylex(void);
extern char *yytext;
extern int linha;
extern FILE *yyin;
void yyerror(char *s);

typedef struct{
	char variavel[64];
	double valor;
}SVAR;
SVAR svar[64] = {};
int tamanho = sizeof(svar)/sizeof(SVAR);
%}

%union{
	double real;
	char string[64];
	int inteiro;
}

%token <real> NUMERO
%token <string> VARIAVEL
%token '(' ')' '+' '-' '*' '/' '^' '='
%token <string> INICIO FIM PRINT LET

%type <real> exp valor

%right PRINT
%right VARIAVEL
%right '='
%right '('
%left ')'
%right '+' '-'
%left '*' '/'
%right '^'
%left LET
%left FIM
%right INICIO

%%

programa: INICIO cod FIM 
	;

cod: cod cmdos
	|
	;

cmdos: PRINT exp {
		printf ("%f \n",$2);
	}
	| LET VARIAVEL {
		int x = 0;
		bool existe = false;
		for(x; x<tamanho; x++){
			if(strcmp(svar[x].variavel, $2)==0){
				existe = true;
				break;
			}
		}
		if( !existe )/*SE NAO EXISTE*/{
			x=0;
			for(x; strcmp(svar[x].variavel, "")!=0 && x<tamanho; x++);
			strcpy(svar[x].variavel, $2);
		}
	}
	| LET VARIAVEL '=' exp {
		int x = 0;
		bool existe = false;
		for(x; x<tamanho; x++){
			if(strcmp(svar[x].variavel, $2)==0){
				existe = true;
				break;
			}
		}
		if( !existe )/*SE NAO EXISTE*/{
			x=0;
			for(x; strcmp(svar[x].variavel, "")!=0 && x<tamanho; x++);
			strcpy(svar[x].variavel, $2);
			svar[x].valor = $4;
		}
	}
	| VARIAVEL '=' exp {
		int x = 0;
		bool teste = false;
		for(x; x<tamanho; x++){
			if(strcmp(svar[x].variavel, $1)==0){
				svar[x].valor = $3;
				teste = true;
				break;
			}
		}
		if(teste==false)/*SE NAO EXISTE*/{
			char msg[] = "";
			strcat(msg, "variavel ");
			strcat(msg, $1);
			strcat(msg," nao declarada.");

			yyerror(msg);
		}
	}
	| exp
	;

exp: exp '*' exp {$$=$1*$3;}
	|exp '+' exp {$$=$1+$3;}
	|exp '-' exp {$$=$1-$3;}
	|exp '/' exp {$$=$1/$3;}
	|'(' exp ')' {$$=$2;}
	|exp '^' exp {$$=pow($1, $3);}
	|'-' exp {$$= -$2;}
	|valor {$$=$1;}
	|VARIAVEL {
		int x=0;
		bool teste = false;
		for(x; x<tamanho; x++){
			if(strcmp(svar[x].variavel, $1)==0){
				$$=svar[x].valor;
				teste = true;
				break;
			}
		}
		if(!teste){
			char msg[] = "";
			strcat(msg, "variavel ");
			strcat(msg, $1);
			strcat(msg," nao declarada.");

			yyerror(msg);
		}
	}
	;

valor: NUMERO {$$=$1;}
	;

%%

#include "lex.yy.c"

void yyerror(char *s)
{
  printf("Error sintactico na linha %d: %s\n", linha, s);
  exit(1);
}

int main(){
	SVAR b = {"", 0};
	int x;
	for(x=0; x<tamanho; x++){
		svar[x] = b;
	}
	yyin=fopen("entrada.txt","r");
	yyparse();
	//yylex();
	fclose(yyin);
	
	return 0;
}

