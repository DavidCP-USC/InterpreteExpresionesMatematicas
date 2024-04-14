%{
    #include "TS.h"
    #include "AnalizadorSintactico.tab.h"
    #include "Errores.h"
    
    
    // Función para imprimir la ayuda
    void ayuda(){
        printf("\nComandos:\n");
        printf("help\t\t\tMostrar ayuda.\nload <path>\t\tCargar un fichero con instrucciones y ejecutarlas.\nvars\t\t\tMostrar las variables de la tabla de símbolos.\nfuncs\t\t\tMostrar las funciones de la tabla de símbolos.\nreset\t\t\tBorrar las variables de la calculadora.\nsalir/exit\t\tSalir del programa.\n");
        printf("\nOperaciones disponibles y ejemplos:\n");
        printf("+\tSuma \t\t a + a\n-\tResta \t\t a - a\n*\tMultiplicación \t a * a\n/\tDivisión \t a / a\n^\tElevar \t\t a ^ a\n=\tIgualar  \t a = a\n\n");
        printf("\n\tNota1: se puede introducir o no introducir espacios entre las operaciones y los números\n");
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


IDENTIFICADOR       [_a-zA-Z][_a-zA-Z0-9]*
TOKENSIMPLE         [\+\-\*\/\=\(\)\;\^]
NOMBREFICHERO       [a-zA-Z0-9]([a-zA-Z0-9])*
EXTENSION           ([a-zA-Z])*
RUTA                {NOMBREFICHERO}"."?{EXTENSION}
CARGA               "load "|"LOAD "
AYUDA               "help"|"HELP"
SALIR               "salir"|"SALIR"|"exit"|"EXIT"
VARIABLE            "vars"|"VARS"
FUNCION             "funcs"|"FUNCS"
REINICIAR           "reset"|"RESET"

%%

{AYUDA} /* Comando de ayuda */ {
    ayuda();
    printf("> ");
    BEGIN(INITIAL);
}

{CARGA}{RUTA} /* Comando para cargar un archivo */ {
    yyin = fopen(yytext+5, "r+"); /* Abrimos el archivo */
    if(!yyin){ /* Comprobamos si el archivo se abrió correctamente */
        imprimirError(1, yytext+5);
        yyin=stdin; /* Establecemos la entrada estándar como entrada predeterminada */
    }
    printf("Archivo %s ejecutado correctamente\n", yytext+5);
    BEGIN(INITIAL);
}

{REINICIAR} /* Función para mostrar las variables de la tabla de símbolo */ {
    reiniciarTS();
    printf("Sistema reiniciado\n");
    printf("> ");
    BEGIN(INITIAL);
}

{SALIR} /* Función para salir del programa */ {
    printf("Saliendo del interprete\n");
    return EXIT;
}

{FUNCION} /* Función para mostrar las variables de la tabla de símbolo */ {
    imprimirFunciones();
    printf("> ");
    BEGIN(INITIAL);
}

{VARIABLE} /* Función para mostrar las variables de la tabla de símbolo */ {
    imprimirVariables();
    printf("> ");
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
    s = buscarNodo(yytext); /* Intentamos obtener el dato de la tabla de símbolos */
    if(s == NULL){ /* Si no está en la tabla es una variable */
        s = crearNodo(yytext, VAR, 0);
        yylval.VAR = s;
        return VAR;
    }
    if(s->tipo == VAR){ /* Si es constante o variable */
        yylval.VAR = s; /* Introducimos el valor*/
    }
    else{ /*Si es una función */
        yylval.FNCT = s; /* Introducimos el valor*/
    }
    return s->tipo;
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