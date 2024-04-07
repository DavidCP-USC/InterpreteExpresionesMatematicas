%{  //declaraciones en C
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include "estructura.h"
    #include "gestionErrores.h"

    int yylex(); //Función del analizador léxico
    void yyerror(char *s); //Función de informe de errores
%}

/* Declaraciones de Bison */
%define api.value.type union
%token <double>  NUM
%token <symrec*> VAR FNCT
%token EXIT
%token UNEXPECTED
%type <double> exp

/* Precedencia de operadores*/
%precedence '='
%left '+' '-'
%left '*' '/'
%precedence NEG
%right '^'

%%

/* Reglas gramaticales. Para cada regla, definimos la acción a tomar cuando una instancia de esa regla sea reconocida */

input:  /* vacío */
    | input line
;

line: '\n'
    | exp '\n'      { printf("\t%.10g\n",$1); }
    | exp ';' '\n'  { printf("\t%.10g\n",$1); }
    | error '\n'    { yyerrok;                }
    | EXIT '\n'     { 
         destruirTablaSimbolos(); /* Destruimos la tabla de Simbolos antes de salir */
         exit(0); 
    }
;

exp: NUM                 { $$ = $1; }
    | VAR                { $$ = $1->value.var; }
    | FNCT '=' exp       {
        imprimirError(2,$1->name);
        return 0;
    }

    | VAR '=' exp        { 
        if($1->constant == 'n'){
            $1->value.var = $3;
            $$ = $3;
        }
        else{
            imprimirError(3,$1->name);
            return 0;
        }
    }

    | FNCT '(' exp ')'   { $$ = (*($1->value.fnctptr))($3); }
    | exp '+' exp        { $$ = $1 + $3; }
    | exp '-' exp        { $$ = $1 - $3; }
    | exp '*' exp        { $$ = $1 * $3; }
    | exp '/' exp        {
        if($3 != 0){
            $$ = $1 / $3;
        }
        else{
            imprimirError(4,"");
            return 0;
        }
    }
    | '-' exp  %prec NEG { 
        if($2 != 0){
            $$ = -$2;
        }
        else{ /* Si es cero no se niega el resultado */
            $$ = $2; 
        }
    }
    | exp '^' exp        { $$ = pow ($1, $3); }
    | '(' exp ')'        { $$ = $2; }
;

%%
 /*Codigo adicional*/
void yyerror(char *s){ 
    imprimirError(5, s);
}