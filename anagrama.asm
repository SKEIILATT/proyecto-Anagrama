;Define el modelo de memoria del programa
.model small                             
;Reserva 256 bytes para la pila
.stack 100h                    
;Seccion para inicializar variables y datos
.data
; Mensajes a mostrar en pantalla
prompt_1  db 'Ingrese la primera palabra a analizar: $',0
prompt_2  db 'Ingrese la segunda palabra a analizar: $',0 

;Buffers para permitir las entradas las palabras o frases
buffer_e1 db 45 ; Tamano maximo que el usuario podra ingresar
          db ?  ; Espacio reservado para capturar la cantidad de palabras que el usuario ingresa
          db 45 dup(?) ; Espacio de los caracteres ingresados

buffer_e2 db 45
          db ?
          db 45 dup(?)

;Seccion del codigo
.code
main proc
    ;Inicializacion de datos
    mov ax, @data
    mov ds, ax              
    
    ;Mostrar prompt
    mov dx, offset prompt_1
    mov ah, 09h
    int 21h
    
    ;Leer e inicializar el buffer
    ;Puntero que inicializa al primer buffer
    lea dx, buffer_e1                   
    ;Leo los caracteres ingresados y los guardo
    mov ah, 0Ah
    int 21h
    
    ;Salto de linea
    mov ah, 02h  ; Instruccion de escritura de un caracter
    mov dl, 0Dh  ; Retorno de carro para volver al inicio del prompt
    int 21h      ; Muestro en pantalla
    
    mov ah, 02h  ; Instruccion de escritura de un caracter
    mov dl, 0Ah  ; Instruccion de avance de linea
    int 21h      ; Muestro en pantalla
    
    ;Muestro el segundo prompt
    mov dx, offset prompt_2   
    mov ah, 09h              
    int 21h
    ;Inicializo y cargo en memoria el puntero para el segundo buffer
    lea dx, buffer_e2
    mov ah, 0Ah
    int 21h 
    
    ;Punteros en el primer caracter de cada buffer para comenzar con el programa
    lea si, buffer_e1+2
    lea di, buffer_e2+2
    
    