#!/bin/bash
flex --header-file="lex.yy.h" AnalizadorLexico.l
bison -d -Wconflicts-sr AnalizadorSintactico.y
gcc main.c AnalizadorSintactico.tab.c TS.c Errores.c -lm -lfl -o practica3.out
