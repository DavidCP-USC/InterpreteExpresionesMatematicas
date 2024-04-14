// Puntero a función que recibe un double y devuelve un double
typedef double (*func_t) (double); 

// Definimos el tipo de dato que se almacenará en la lista
typedef struct {
    char *nombre; // Nombre
    int tipo; // Tipo: VAR o FNCT
    union {
        double valor; // Valor de la variable
        func_t funcion; // Puntero a la función
    } valor;
    int constante; // 1 si es constante, 0 si no lo es
    struct Nodo *siguiente; // Puntero al siguiente Nodo
}Nodo;

extern Nodo *TS; // Tabla de símbolos

/*      Funciones       */
// Inicializar la tabla de símbolos
void initTS(); 

// Destruir la tabla de símbolos
void destruirTS(); 

// Elimina un nodo de la tabla de símbolos
/*
    @param nodo: Puntero al nodo a eliminar
*/
void eliminarNodoTS(Nodo **nodo); 

// Crear un nodo a partir de sus datos
/*
    @param nombre: Nombre del nodo
    @param tipo: Tipo del nodo (Variable = 0, Función = 1)
    @param valor: Valor del nodo
    @param constante: 1 si es constante, 0 si no lo es
    
    @return: Puntero al nodo creado
*/
Nodo *crearNodo(char *nombre, int tipo, int constante); 

// Insertar un nodo en la tabla de símbolos
/*
    @param nodo: Puntero al nodo a insertar
*/
void insertarNodo(Nodo *nodo); 

// Buscar un nodo en la tabla de símbolos
/*
    @param nombre: Nombre del nodo a buscar
    
    @return: Puntero al nodo buscado
*/
Nodo *buscarNodo(char *nombre); // Busca un nodo en la tabla de símbolos

// Imprimir las funciones almacenadas en la tabla de símbolos
void imprimirFunciones();

// Imprimir las variables almacenadas en la tabla de símbolos
void imprimirVariables();

// Reiniciar la tabla de símbolos
void reiniciarTS(); 
