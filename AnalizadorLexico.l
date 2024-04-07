%{
    #include "estructura.h"
    #include "ccASint.tab.h"
    #include "gestionErrores.h"
    
    // Función para imprimir la ayuda
    void ayuda(){
        
        printf("\nComandos disponibles:\n");
        printf("ayuda/help\t\tMostrar ayuda.\nload <path>\tCargar un fichero con instrucciones y ejecutarlas.\nvars\t\t\tMostrar las variables de la tabla de símbolos.\nfuncs\t\t\tMostrar las funciones de la tabla de símbolos.\nreset\t\t\tBorrar las variables de la calculadora.\nsalir/exit\t\tSalir del programa.\n");
        printf("\n\tNota: los comandos se pueden introducir en mayúsculas o minúsculas\n");
        printf("\nOperaciones básicas disponibles y ejemplos:\n");
        printf("+\tSuma \t\t a + a\n-\tResta \t\t a - a\n*\tMultiplicación \t a * a\n/\tDivisión \t a / a\n^\tElevar \t\t a ^ a\n=\tIgualar  \t a = a\n\n");
        printf("\n\tNota: se puede introducir o no introducir espacios entre las operaciones y los números\n\n");
    }

    symrec *s;
    
%}

%option noyywrap

DIGITO              [0-9]
ENTERO              ({DIGITO}[_]?)+
CIENTIFICO          {ENTERO}[eE][+-]?{ENTERO}
DECIMAL             {ENTERO}"."{ENTERO}
DECIMALCIENTIFICO   {DECIMAL}[eE][+-]?{ENTERO}
IDENTIFICADOR       [_a-zA-Z][_a-zA-Z0-9]*
TOKENSIMPLE         [\+\-\*\/\=\(\)\;\^]
NOMBREFICHERO       [a-zA-Z0-9]([a-zA-Z0-9])*
EXTENSION           ([a-zA-Z])*
RUTA                {NOMBREFICHERO}"."?{EXTENSION}
CARGA               "load "|"LOAD "
AYUDA               "ayuda"|"AYUDA"|"help"|"HELP"
SALIR               "salir"|"SALIR"|"exit"|"EXIT"
VARIABLE            "vars"|"VARS"
FUNCION             "funcs"|"FUNCS"
REINICIAR           "reset"|"RESET"

%%

{AYUDA} /* Comando de ayuda */ {
    ayuda();
    BEGIN(INITIAL);
}

{CARGA}{RUTA} /* Comando de carga de fichero */ {
    FILE* fp = fopen(yytext+5, "r+"); /* Leemos el fichero */
    if(!fp){ /* Comprobamos la incorrecta apertura del fichero */
        imprimirError(1, yytext+5);
        yyin=stdin; /* Entrada por defecto la entrada del sistema */
    }
    else{
        yyin = fp; /* Entrada por defecto el fichero proporcionado */
    }
    BEGIN(INITIAL);
}

{REINICIAR} /* Función para mostrar las variables de la tabla de símbolo */ {
    reiniciarTablaSimbolos();
    printf("Sistema reiniciado\n");
    BEGIN(INITIAL);
}

{SALIR} /* Función para salir del programa */ {
    printf("Saliendo del interprete\n");
    BEGIN(INITIAL);
    return EXIT;
}

{FUNCION} /* Función para mostrar las variables de la tabla de símbolo */ {
    imprimirFunciones();
    BEGIN(INITIAL);
}

{VARIABLE} /* Función para mostrar las variables de la tabla de símbolo */ {
    imprimirVariables();
    BEGIN(INITIAL);
}

{ENTERO} /* Enteros */ {
    yylval.NUM = atof(yytext);
    return NUM;

}

{CIENTIFICO} /* Científico */ {
    yylval.NUM = atof(yytext);
    return NUM;
}

{DECIMAL} /* Decimal */ {
    yylval.NUM = atof(yytext);
    return NUM;
}

{DECIMALCIENTIFICO} /* Decimal Científico */ {
    yylval.NUM = atof(yytext);
    return NUM;
}

{IDENTIFICADOR} /* Identificador */ {
    s = getsym(yytext); /* Intentamos obtener el dato de la tabla de símbolos */
    if(s == 0){ /* Si no está en la tabla es una variable */
        s = putsym(yytext, VAR, 'n'); /* La introducimos en la tabla de símbolos*/
    }
    if(s->type==VAR){ /* Si es constante o variable */
        yylval.VAR = s; /* Introducimos el valor*/
    }
    else{ /*Si es una función */
        yylval.FNCT = s; /* Introducimos el valor*/
    }
    return s->type;
}

{TOKENSIMPLE} /*TOKEN Simple*/ return yytext[0] ;

\n /* Salto de linea */ return '\n';
<<EOF>> {
    fclose(yyin);
    yyin=stdin;
    yyrestart(yyin);
    BEGIN(INITIAL);
    return '\n'; /* Necesario para que funcione la lectura de lectura de archivo, sino si no acaba el archivo con un salto de línea "Kaboom" */
}
[ \t\r\b\f] /* Simbolos que no se tienen que contemplar */
%%