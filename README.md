# InterpreteExpresionesMatematicas

Proyecto realizado para la asignatura de Compiladores e Intérpretes del grado de Ingeniería Informática de la Universidad de Santiago de Compostela.

Se busca construir un intérprete de expreisones de cálculo matemático y ficheros con secuencias de expresiones.

El intérprete incorpora algunas de las operaciones aritméticas y funciones propias de una calculadora científica (sin(),cos(),log(),exp(),…), aplicadas a números tanto enteros como reales en notación científica.

Este intérprete despone de un juego de comandos que facilitan su uso, y que permiten solicitar ayuda, cargar ficheros de expresiones, imprimir el contenido de las variables definidas en el espacio de trabajo, eliminar el propio espacio de trabajo o salir del programa, entre otros.

## Requisitos

* GNU GCC
* Flex
* Bison (GNU Bison)

## Versiones probadas

* GNU GCC 11.4.0
* Flex 2.6.4
* Bison (GNU Bison) 3.8.2

Todas las pruebas se han hecho bajo Ubuntu 22.04.4

## Compilación

Para compilar el proyecto es necesario tener todos los archivos en la misma carpeta y ejecutar el script ```compile.sh``` que, de no tener premisos de ejecución, se le deben otorgar con el comando ```chmod +x ./ejecutable```. Se generará un archivo ```practica3.out``` al que debemos también otorgarle permisos de ejecución con el comando facilitado anteriormente

## Ejecución

La ejecución es muy sencilla, simplemente ejecutamos el archivo ```pruebas.out``` que se genera tras la compilación.

## Funciones y comandos

* help: Muestra la ayuda.
* load path: Carga un fichero con expresiones matemáticas y las ejecuta.
* vars: Muestra las variables disponibles (aquellas almacenadas en la Tabla de Símbolos)
* funcs: Muestra las funciones disponibles (aquellas almacenadas en la Tabala de Símbolos)
* reset: Borra todas las variables almacenadas por el usuario.
* salir / exit: Se finaliza el programa

### Notas extra

* Se pueden introduceir o no espacios entre las operaciones y los numeros
* Si se termina una sentencia sin el caracter ```;```, el resultado no se mostrará por pantalla
* Los comandos pueden ser escritos tanto en mayúsculas como en minúsculas
