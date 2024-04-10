#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "TS.h"
#include <math.h>
#include "definiciones.h"
#include "AnalizadorSintactico.tab.h"

// Patron de diseno Singleton
Nodo *TS;

void initTS(){
    // Introductir las funciones
    for (int i = 0; i < NUM_FUNCIONES; i++){
        Nodo *nodo = crearNodo(funciones[i].nombre, FNCT, 0);
        nodo->valor.funcion = funciones[i].funcion;
        insertarNodo(nodo);
    }

    // Introducir las constantes
    for (int i = 0; i < NUM_CONSTANTES; i++){
        Nodo *nodo = crearNodo(constantes[i].nombre, VAR, 1);
        nodo->valor.valor = constantes[i].valor;
        insertarNodo(nodo);
    }
}

// Destruir la tabla de símbolos
void destruirTS(){
    if (TS != NULL) {
        eliminarNodoTS(&TS);
    }
    TS = NULL;
}

// Eliminar un nodo de la tabla de símbolos
void eliminarNodoTS(Nodo **nodo){
    if ((*nodo)->siguiente != NULL){
        eliminarNodoTS((Nodo **)&((*nodo)->siguiente));
    }
    free((*nodo)->nombre);
    free(*nodo);
}

// Crear un nodo a partir de sus datos
Nodo *crearNodo(char const *nombre, int tipo, int constante){
    Nodo *nodo = (Nodo *)malloc(sizeof(Nodo));
    nodo->nombre = (char *)malloc(strlen(nombre) + 1);
    strncpy(nodo->nombre, nombre, strlen(nombre) + 1);
    nodo->nombre[strlen(nombre)] = '\0';
    nodo->tipo = tipo;
    nodo->constante = constante;
    nodo->siguiente = NULL;
    return nodo;
}

// Insertar un nodo en la tabla de símbolos
// Nota: Se inserta al principio de la lista para mayor eficiencia en la inserción
void insertarNodo(Nodo *nodo){
    if (TS == NULL){
        TS = nodo;
    } else {
        nodo->siguiente = (struct Nodo *)TS;
        TS = nodo;
    }
}

// Buscar un nodo en la tabla de símbolos
Nodo *buscarNodo(char const *nombre){
    Nodo *nodo = TS;
    while (nodo != NULL){
        if (strcmp(nodo->nombre, nombre) == 0){
            return nodo;
        }
        nodo = (Nodo *)nodo->siguiente;
    }
    return NULL;
}

// Imprimir las funciones almacenadas en la tabla de símbolos
void imprimirFunciones(){
    Nodo *nodo = TS;
    printf("========== Funciones ==========\n");
    while (nodo != NULL){
        if (nodo->tipo == FNCT){
            printf("%s ()\n", nodo->nombre);
        }
        nodo = (Nodo *)nodo->siguiente;
    }
    printf("===============================\n");
}

// Imprimir las variables almacenadas en la tabla de símbolos
void imprimirVariables(){
    Nodo *nodo = TS;
    printf("==== Variables almacenadas ====\n");
    while (nodo != NULL){
        if (nodo->tipo == VAR){
            printf("%s = %lf\n", nodo->nombre, nodo->valor.valor);
        }
        nodo = (Nodo *)nodo->siguiente;
    }
    printf("===============================\n");
}

// Reiniciar la tabla de símbolos
void reiniciarTS(){
    if (TS != NULL){
        destruirTS();
    }
    initTS();
}