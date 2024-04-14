%{
    #include "TS.h"
    #include "AnalizadorSintactico.tab.h"
    #include "Errores.h"
    
    
    // Funcion para imprimir la ayuda
    void help(){
        printf("\nComandos:\n");
        printf("help\t\t\tMostrar ayuda.\nload <path>\t\tCargar un fichero con instrucciones y ejecutarlas.\nvars\t\t\tMostrar las variables de la Tabla de Simbolos.\nfuns\t\t\tMostrar las funciones de la Tabla de Simbolos.\nreset\t\t\tBorrar las variables de la calculadora.\nquit / exit\t\tSalir del programa.\n");
        printf("\nOperaciones disponibles y ejemplos:\n");
        printf("+\tSuma \t\t a + a\n-\tResta \t\t a - a\n*\tMultiplicacion \t a * a\n/\tDivision \t a / a\n^\tElevar \t\t a ^ a\n=\tIgualar  \t a = a\n\n");
        printf("\n\tNota1: se puede introducir o no espacios entre las operaciones y los numeros\n");
        printf("\n\tNota2: si se termina una sentencia sin \";\" el resultado no aparecera por pantalla\n\n");
    }

    Nodo *s;
    
%}

%option noyywrap


DIGITO              [0-9]
ENTERO              ({DIGITO}[_]?)+
CIENTIFICO          {ENTERO}[eE][+-]?{ENTERO}
DECIMAL             {ENTERO}"."{ENTERO}
DECIMALCIENTIFICO   {DECIMAL}[eE][+-]?{ENTERO}


HELP                "help"|"HELP"
SALIR               "quit"|"QUIT"|"exit"|"EXIT"
ID                  [_a-zA-Z][_a-zA-Z0-9]*
TOKENUNICARACTER    [\+\-\*\/\=\(\)\;\^]
RESET               "load "|"LOAD "
FILENAME            [a-zA-Z0-9]([a-zA-Z0-9])*
VARIABLE            "vars"|"VARS"
FUNCION             "funs"|"FUNS"
EXTENSION           ([a-zA-Z])*
RUTA                {FILENAME}"."?{EXTENSION}
REINICIAR           "reset"|"RESET"

%%

{HELP} {
    help();
    printf("> ");
    BEGIN(INITIAL);
}


{SALIR} {
    printf("Saliendo del programa...\n");
    return EXIT;
}



{REINICIAR} {
    /* Funcion para mostrar las variables de la Tabla de Simbolo */
    reiniciarTS();
    printf("Variables eliminadas correctamente\n");
    printf("> ");
    BEGIN(INITIAL);
}

{RESET}{RUTA} {
    /* Comando para leer un archivo y ejecutar sus expresiones matematicas */
    yyin = fopen(yytext+5, "r+"); 
    if(!yyin){ 
        imprimirError(1, yytext+5);
        yyin=stdin; 
    }
    printf("Archivo %s abierto correctamente\n", yytext+5);
    BEGIN(INITIAL);
}


{FUNCION} {
    /* Funcion que muestra por pantalla las funciones almacenadas en la Tabla de Simbolos */
    imprimirFunciones();
    printf("> ");
    BEGIN(INITIAL);
}


{VARIABLE} {
    /* Funcion que muestra por pantalla las variables almacenadas en la Tabla de Simbolos */
    imprimirVariables();
    printf("> ");
    BEGIN(INITIAL);
}


{ENTERO} {
    yylval.NUM = atof(yytext);
    return NUM;

}

{CIENTIFICO} {
    yylval.NUM = atof(yytext);
    return NUM;
}

{DECIMAL} {
    yylval.NUM = atof(yytext);
    return NUM;
}


{DECIMALCIENTIFICO} {
    yylval.NUM = atof(yytext);
    return NUM;
}



{ID} {
    /* Se busca el identificador en la TS. Si no existe se indica para que se cree 
    en el analizador sintactico. Si existe se indica si es una variable o una constante*/
    s = buscarNodo(yytext); 
    if(s == NULL){ 
        s = crearNodo(yytext, VAR, 0);
        yylval.VAR = s;
        return VAR;
    }
    if(s->tipo == VAR){ 
        yylval.VAR = s; 
    }
    else{
        yylval.FNCT = s; 
    }
    return s->tipo;
}

{TOKENUNICARACTER}  return yytext[0] ;

\n  return '\n';
<<EOF>> {
    fclose(yyin);
    yyin=stdin;
    yyrestart(yyin);
    BEGIN(INITIAL);
    printf("Se termino de leer el archivo\n> ");
    return '\n';
}


[ \t\r\b\f] /* Simbolos que se descartan */
%%