#include <stdio.h>
#include <stdlib.h>
#include "lex.yy.c"
#include "AnalizadorSintactico.tab.h"

int main(int argc, char *argv[]){
    initTS();

    yyin = stdin; // Definimos la entrada de flex como la entrada del sistema
    printf("Puede obtener ayuda con el comando \"help\"\n");
    while(1){
        yyparse(); // Lanzamos la ejecución del analizador sintáctico
    }
    return 0;
}