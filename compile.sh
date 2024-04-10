#!/bin/bash
bison -d AnalizadorSintactico.y
flex AnalizadorLexico.l
gcc main.c AnalizadorSintactico.tab.c TS.c Errores.c -lm -lfl -o practica3.out