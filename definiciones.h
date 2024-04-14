#define NUM_FUNCIONES 9
#define NUM_CONSTANTES 2


// Datos necesarios para inicializar la tabla de simbolos
typedef struct{
    char *nombre;
    double (*funcion)(double);
}Funcion;

typedef struct{
    char *nombre;
    double valor;
}Constante;

// Funciones a introducir en la tabla de simbolos
Funcion funciones[NUM_FUNCIONES] = {
    {    "sqrt", sqrt    },
    {    "exp",  exp     },
    {    "ln",   log     },
    {    "sin",  sin     },
    {    "cos",  cos     },
    {    "tan",  tan     },
    {    "asin", asin    },
    {    "acos", acos    },
    {    "atan", atan    },
};

// Constantes a introducir en la tabla de simbolos
Constante constantes[NUM_CONSTANTES] = {
    {    "pi", M_PI     },
    {    "e",  M_E      },
};
 