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
    ;Salto de linea
    mov ah, 02h  ; Instruccion de escritura de un caracter
    mov dl, 0Dh  ; Retorno de carro para volver al inicio del prompt
    int 21h      ; Muestro en pantalla
    
    mov ah, 02h  ; Instruccion de escritura de un caracter
    mov dl, 0Ah  ; Instruccion de avance de linea
    int 21h      ; Muestro en pantalla
    
    ;Punteros en el primer caracter de cada buffer para comenzar con el programa
    lea si, buffer_e1+2
    lea di, buffer_e2+2 
 
    ;Iniciar contador para convertir en minuscula todas las letras
    mov cl, [buffer_e1+1] 
    mov ch, 0
    
verificar_letra_b1:   
    ;Movemos el puntero al primer caracter del buffer
    mov al, [si]                                     
    ;Comparo el valor ASCII de ambos caracteres
    ;Para saber si es mayuscula, el valor ASCII debe de estar entre 65 y 90 
    cmp al, 'A' ; 'A' representa el 65 en ASCII 
    ;Si el codigo ASCII de al es menor que 65, salta a no_es_mayus debido a que ya sabemos que no sera mayuscula
    jl no_es_mayus_b1
    cmp al, 'Z'; 'Z' representa el 90 en ASCII
    ;Si es mayor que 90, saltamos de igual manera a no_es_mayus debido a que ya sabemos que no es mayuscula
    jg no_es_mayus_b1
    ;Si es mayuscula, la transformamos a minuscula
    add al, 'a'- 'A' ; Para transformar a minuscula, basta con restar la diferencia entre el valor ASCII de la minuscula con la mayuscula
    ;Reescribimos en el buffer el nuevo valor
    mov [si], al

;Etiqueta que dado que no es mayuscula, avanza al siguiente caracter y repite el bucle
no_es_mayus_b1:
    inc si
    loop verificar_letra_b1    
    
    mov cl, [buffer_e2+1]
    mov ch, 0

verificar_letra_b2:   
    ;Movemos el puntero al primer caracter del buffer
    mov al, [di]                                     
    ;Comparo el valor ASCII de ambos caracteres
    ;Para saber si es mayuscula, el valor ASCII debe de estar entre 65 y 90 
    cmp al, 'A' ; 'A' representa el 65 en ASCII 
    ;Si el codigo ASCII de al es menor que 65, salta a no_es_mayus debido a que ya sabemos que no sera mayuscula
    jl no_es_mayus_b2
    cmp al, 'Z'; 'Z' representa el 90 en ASCII
    ;Si es mayor que 90, saltamos de igual manera a no_es_mayus debido a que ya sabemos que no es mayuscula
    jg no_es_mayus_b2
    ;Si es mayuscula, la transformamos a minuscula
    add al, 'a'- 'A' ; Para transformar a minuscula, basta con restar la diferencia entre el valor ASCII de la minuscula con la mayuscula
    ;Reescribimos en el buffer el nuevo valor
    mov [di], al

;Etiqueta que dado que no es mayuscula, avanza al siguiente caracter y repite el bucle
no_es_mayus_b2:
    inc di
    loop verificar_letra_b2
           
    ;Esta seccion solo la puse para probar que vale xd lo de no case sensitive"
    ;Esto despues se borrar y se sigue con la logica
    ;Mostrar cadena
    lea si, buffer_e1+2
    mov cl, [buffer_e1+1]
    mov ch, 0
    add si, cx
    mov byte ptr [si], '$'
    lea dx, buffer_e1+2
    mov ah, 09h
    int 21h 
    ;Salto de linea
    mov ah, 02h  ; Instruccion de escritura de un caracter
    mov dl, 0Dh  ; Retorno de carro para volver al inicio del prompt
    int 21h      ; Muestro en pantalla
        
    mov ah, 02h  ; Instruccion de escritura de un caracter
    mov dl, 0Ah  ; Instruccion de avance de linea
    int 21h      ; Muestro en pantalla
        
    ;Mostrar cadena
    lea di, buffer_e2+2
    mov cl, [buffer_e2+1]
    mov ch, 0
    add di, cx
    mov byte ptr [di], '$'
    lea dx, buffer_e2+2
    mov ah, 09h
    int 21h          
    
    ;Terminar programa
    mov ah, 4Ch
    int 21h
    
    main endp
    end main
    
    
    
    
        
    
 
    
    
    
    
    
                      