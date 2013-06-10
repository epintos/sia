Pasos para correr el trabajo practico:

1. Inicializar octave
2. Correr 'main' para cargar el trabajo
3. Si se desea correr con una arquitectura distinta o con un problema que no sea el presentado en el TP, seguir los pasos a, b y c, sino correr 'run'.
3.a Para elegir el tipo de problema a correr setear network.problem = problem.{nombredeproblema}(n,functs.{funciondeactivacion}) 
3.b Para setear la arquitectura setear network.neuronsPerLayer = [a b c .. z] donde cada letra es la cantidad de neuronas en cada capa, z debe ser 1.
3.c Correr network.train(n) donde n es T en el caso del problema presentado.

Los problemas a evaluar son:
and, or, xor, simmetry, approximation (este ultimo es el deseado en el trabajo practico parte 2).

Las funciones de activacion son:
tanh, exp  

