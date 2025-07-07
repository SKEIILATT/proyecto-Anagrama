;Define el modelo de memoria del programa
.model small                             
;Reserva 256 bytes para la pila
.stack 100h                    
;Seccion para inicializar variables y datos
.data
; Mensajes a mostrar en pantalla
prompt_1  db 'Ingrese la primera palabra a analizar: $',0
prompt_2  db 'Ingrese la segunda palabra a analizar: $',0  
msgnoAnagrama db 'No son anagrama $',0
msgsiAnagrama db 'Son anagrama $',0
contador_1 db 27 dup(0) ; Contadores que nos sirven para verificar la cantidad de letras que hay en las palabras
                        ; para poder determinar si son anagramas o no, sin necesidad de ordenarlas
contador_2 db 27 dup(0) ; Lo mismo pero para el segundo buffer 
                                      
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
  
;Verificar longitud de cada palabra para ver si son anagramas o no
mov al,[buffer_e1+1] ;Accedemos a la cantidad real de car�cteres ingresados por el usuario     
mov bl, [buffer_e2+1]
cmp al, bl 
jne no_esAnagrama
je verificar_caracteres  
      
verificar_caracteres:  
    ;Reiniciar punteros para iniciar recorridos
    lea si, buffer_e1+2
    lea di, buffer_e2+2
    ;Inicializamos elcontador
    mov cl, [buffer_e1+1];    
;En esta seccion verificamos si el caracter tiene tilde o no para no afectar 
contar_b1:  
    ;Comparamos si alguna vocal tiene tilde
    mov al, [si]
    cmp al, 160 ;comparamos si el valor ascii de la vocal a es el mismo valor ascii de la �.
    je es_a_b1
    cmp al, 130 
    je es_e_b1
    cmp al, 161
    je es_i_b1
    cmp al, 162 
    je es_o_b1
    cmp al, 163
    je es_u_b1 
    ;Comparamos si est� presente la �
    cmp al, 164
    je es_enie_b1  
    ;Calculamos el indice
    sub al, 'a'
    cmp al, 14
    jl contar_ok_b1
    inc al
    jmp contar_ok_b1


es_a_b1:
    mov al, 0
    jmp contar_ok_b1

es_e_b1:
    mov al, 4
    jmp contar_ok_b1

es_i_b1:
    mov al, 8
    jmp contar_ok_b1

es_o_b1:
    mov al, 15   ; o  �ndice 15 (despu�s de �)
    jmp contar_ok_b1

es_u_b1:
    mov al, 20
    jmp contar_ok_b1

es_enie_b1:
    mov al, 14   ; �  �ndice 14
    
contar_ok_b1:
    mov bl, al
    mov bh, 0               ; Limpio BH para tener BX = AL
    add bx, offset contador_1  ; BX = direcci�n base + �ndice
    inc byte ptr [bx]       ; Incremento el contador
    inc si
    loop contar_b1
    
;El mismo proceso para la palabra 2
mov cl, [buffer_e2+1]  ; Inicializar contador con longitud de la segunda palabra
mov ch, 0              ; Limpio la  parte alta del contador  

contar_b2:
    mov al, [di]

    cmp al, 160
    je es_a_b2
    cmp al, 130
    je es_e_b2
    cmp al, 161
    je es_i_b2
    cmp al, 162
    je es_o_b2
    cmp al, 163
    je es_u_b2

    cmp al, 164
    je es_ene_b2

    sub al, 'a'
    cmp al, 14
    jl contar_ok_b2
    inc al
    jmp contar_ok_b2

es_a_b2:
    mov al, 0
    jmp contar_ok_b2

es_e_b2:
    mov al, 4
    jmp contar_ok_b2

es_i_b2:
    mov al, 8
    jmp contar_ok_b2

es_o_b2:
    mov al, 15
    jmp contar_ok_b2

es_u_b2:
    mov al, 20
    jmp contar_ok_b2

es_ene_b2:
    mov al, 14

contar_ok_b2:
    mov bl, al
    mov bh, 0
    inc [contador_2+bx]
    inc di
    loop contar_b2  ; Ahora el bucle terminar� correctamente

    ; ----- COMPARAR -----
    lea si, contador_1
    lea di, contador_2
    mov cx, 27

comparar:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne no_esAnagrama
    inc si
    inc di
    loop comparar

    ; Si son iguales: s� es anagrama
    mov dx, offset msgsiAnagrama
    mov ah, 09h
    int 21h
    jmp fin

no_esAnagrama:
    mov dx, offset msgnoAnagrama
    mov ah, 09h
    int 21h

fin:
    mov ah, 4Ch
    int 21h
main endp
end main
