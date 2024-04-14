#include "Errores.h"
#include <stdio.h>

void imprimirError(int tipo, char* str){
    switch (tipo){
      case 1:
        printf("Error al abrir el archivo %s\n", str);
        break;
      case 2:
        printf("Error: %s es una palabra reservada.\n",str);
        break;
      case 3:
        printf("Error: %s es una constante.\n",str);
        break;
      case 4:
        printf("Error: No se puede dividir por cero.\n");
        break;
      case 5:
        printf("Error: %s.\n",str);
        break;
      case 6:
        printf("Error: Variable no definida.\n");
        break;
      default:
        printf("Error desconocido.\n");
   }
}