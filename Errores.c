#include "Errores.h"
#include <stdio.h>

void imprimirError(int codigo, char* cadena){
    switch (codigo){
      case 1:
         printf("Error: No se pudo abrir el archivo %s para la entrada.\n", cadena);
         break;
      case 2:
         printf("ERROR: %s es una palabra reservada.\n",cadena);
         break;
      case 3:
         printf("ERROR: %s es una constante y no se puede modificar.\n",cadena);
         break;
      case 4:
         printf("ERROR: División por cero.\n");
         break;
      case 5:
         printf("Error genérico: %s.\n",cadena);
         break;
      case 6:
         printf("Variable %s no definida.\n",cadena);
         break;
      default:
         printf("Error desconocido.\n");
   }
}