#include <stdio.h>
#include <stdlib.h>
#include "TS.h"
#include <math.h>

int main(int argc, char *argv[]){
    initTS();
    imprimirFunciones();
    imprimirVariables();
    destruirTS();



    return 0;
}