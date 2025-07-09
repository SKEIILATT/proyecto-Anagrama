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
prompt_continuar db 'Desea continuar? (S/N): $',0
salto_linea db 0Dh, 0Ah, '$',0
msg_presionar db 'Presione cualquier tecla para continuar...$',0

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

;Buffers sin espacios para el procesamiento
buffer_sin_esp1 db 45 dup(?)
buffer_sin_esp2 db 45 dup(?)
len_sin_esp1 db ?
len_sin_esp2 db ?

;Seccion del codigo
.code
main proc
    ;Inicializacion de datos
    mov ax, @data
    mov ds, ax              
programa_principal:
    ; Limpiar pantalla al inicio
    call limpiar_pantalla
    
    ; Limpiar contadores
    call limpiar_contadores
    
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
    mov dx, offset salto_linea
    mov ah, 09h
    int 21h
    
    ;Muestro el segundo prompt
    mov dx, offset prompt_2   
    mov ah, 09h              
    int 21h
    ;Inicializo y cargo en memoria el puntero para el segundo buffer
    lea dx, buffer_e2
    mov ah, 0Ah
    int 21h  
    ;Salto de linea
    mov dx, offset salto_linea
    mov ah, 09h
    int 21h
    
    ; Procesar primera palabra (quitar espacios y convertir a minúsculas)
    call procesar_palabra1
    
    ; Procesar segunda palabra (quitar espacios y convertir a minúsculas)
    call procesar_palabra2
    
    ; Verificar si son anagramas
    call verificar_anagrama
    
    ; Mostrar mensaje para presionar tecla
    mov dx, offset msg_presionar
    mov ah, 09h
    int 21h
    
    ; Esperar tecla
    mov ah, 00h
    int 16h
    
    ; Limpiar pantalla antes de preguntar si continuar
    call limpiar_pantalla
    
    ; Preguntar si continuar
    mov dx, offset prompt_continuar
    mov ah, 09h
    int 21h
    
    mov ah, 01h  ; Leer un caracter
    int 21h
    
    cmp al, 'S'
    je continuar_programa
    cmp al, 's'
    je continuar_programa
    cmp al, 'N'
    je fin_programa
    cmp al, 'n'
    je fin_programa
    jmp fin_programa

continuar_programa:
    jmp programa_principal

fin_programa:
    mov ah, 4Ch
    int 21h
main endp

; Procedimiento para limpiar pantalla
limpiar_pantalla proc
    push ax
    push bx
    push cx
    push dx
    
    ; Limpiar pantalla completa
    mov ah, 06h     ; Función scroll
    mov al, 0       ; Limpiar toda la pantalla
    mov bh, 07h     ; Fondo negro + texto blanco
    mov ch, 0       ; Fila inicial
    mov cl, 0       ; Columna inicial
    mov dh, 24      ; Fila final
    mov dl, 79      ; Columna final
    int 10h
    
    ; Posicionar cursor al inicio
    mov ah, 02h
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
limpiar_pantalla endp

; Procedimiento para limpiar contadores
limpiar_contadores proc
    push ax
    push cx
    push di
    
    lea di, contador_1
    mov cx, 27
    xor al, al
limpiar_loop1:
    mov [di], al
    inc di
    loop limpiar_loop1
    
    lea di, contador_2
    mov cx, 27
limpiar_loop2:
    mov [di], al
    inc di
    loop limpiar_loop2
    
    pop di
    pop cx
    pop ax
    ret
limpiar_contadores endp

; Procedimiento para procesar primera palabra
procesar_palabra1 proc
    push ax
    push bx
    push cx
    push si
    push di
    
    lea si, buffer_e1+2     ; Fuente
    lea di, buffer_sin_esp1 ; Destino
    mov cl, [buffer_e1+1]   ; Longitud
    mov ch, 0
    xor bl, bl              ; Contador de caracteres válidos
    
proc_loop1:
    mov al, [si]
    
    ; Verificar si es espacio, salto de línea o signos de puntuación
    cmp al, ' '
    je skip_char1
    cmp al, 0Dh     ; Retorno de carro
    je skip_char1
    cmp al, 0Ah     ; Salto de línea
    je skip_char1
    cmp al, 09h     ; Tab
    je skip_char1
    cmp al, ','     ; Coma
    je skip_char1
    cmp al, '.'     ; Punto
    je skip_char1
    cmp al, ';'     ; Punto y coma
    je skip_char1
    cmp al, ':'     ; Dos puntos
    je skip_char1
    cmp al, '!'     ; Exclamación
    je skip_char1
    cmp al, '?'     ; Interrogación
    je skip_char1
    cmp al, '-'     ; Guión
    je skip_char1
    cmp al, '_'     ; Guión bajo
    je skip_char1
    cmp al, '('     ; Paréntesis izquierdo
    je skip_char1
    cmp al, ')'     ; Paréntesis derecho
    je skip_char1
    cmp al, '"'     ; Comillas
    je skip_char1
    cmp al, 27h     ; Apostrofe
    je skip_char1
    
    ; Convertir a minúscula si es mayúscula
    cmp al, 'A'
    jl no_mayus1
    cmp al, 'Z'
    jg no_mayus1
    add al, 'a' - 'A'
    
no_mayus1:
    ; Guardar caracter válido
    mov [di], al
    inc di
    inc bl
    
skip_char1:
    inc si
    loop proc_loop1
    
    mov [len_sin_esp1], bl  ; Guardar longitud sin espacios
    
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
procesar_palabra1 endp

; Procedimiento para procesar segunda palabra
procesar_palabra2 proc
    push ax
    push bx
    push cx
    push si
    push di
    
    lea si, buffer_e2+2     ; Fuente
    lea di, buffer_sin_esp2 ; Destino
    mov cl, [buffer_e2+1]   ; Longitud
    mov ch, 0
    xor bl, bl              ; Contador de caracteres válidos
    
proc_loop2:
    mov al, [si]
    
    ; Verificar si es espacio, salto de línea o signos de puntuación
    cmp al, ' '
    je skip_char2
    cmp al, 0Dh     ; Retorno de carro
    je skip_char2
    cmp al, 0Ah     ; Salto de línea
    je skip_char2
    cmp al, 09h     ; Tab
    je skip_char2
    cmp al, ','     ; Coma
    je skip_char2
    cmp al, '.'     ; Punto
    je skip_char2
    cmp al, ';'     ; Punto y coma
    je skip_char2
    cmp al, ':'     ; Dos puntos
    je skip_char2
    cmp al, '!'     ; Exclamación
    je skip_char2
    cmp al, '?'     ; Interrogación
    je skip_char2
    cmp al, '-'     ; Guión
    je skip_char2
    cmp al, '_'     ; Guión bajo
    je skip_char2
    cmp al, '('     ; Paréntesis izquierdo
    je skip_char2
    cmp al, ')'     ; Paréntesis derecho
    je skip_char2
    cmp al, '"'     ; Comillas
    je skip_char2
    cmp al, 27h     ; Apostrofe
    je skip_char2
    
    ; Convertir a minúscula si es mayúscula
    cmp al, 'A'
    jl no_mayus2
    cmp al, 'Z'
    jg no_mayus2
    add al, 'a' - 'A'
    
no_mayus2:
    ; Guardar caracter válido
    mov [di], al
    inc di
    inc bl
    
skip_char2:
    inc si
    loop proc_loop2
    
    mov [len_sin_esp2], bl  ; Guardar longitud sin espacios
    
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
procesar_palabra2 endp

; Procedimiento para verificar anagrama
verificar_anagrama proc
    push ax
    push bx
    push cx
    push si
    push di
    
    ; Verificar longitud
    mov al, [len_sin_esp1]
    mov bl, [len_sin_esp2]
    cmp al, bl
    jne no_es_anagrama
    
    ; Contar caracteres del primer buffer
    lea si, buffer_sin_esp1
    mov cl, [len_sin_esp1]
    mov ch, 0
    
contar_b1:
    mov al, [si]
    call obtener_indice
    mov bl, al
    mov bh, 0
    add bx, offset contador_1
    inc byte ptr [bx]
    inc si
    loop contar_b1
    
    ; Contar caracteres del segundo buffer
    lea si, buffer_sin_esp2
    mov cl, [len_sin_esp2]
    mov ch, 0
    
contar_b2:
    mov al, [si]
    call obtener_indice
    mov bl, al
    mov bh, 0
    add bx, offset contador_2
    inc byte ptr [bx]
    inc si
    loop contar_b2
    
    ; Comparar contadores
    lea si, contador_1
    lea di, contador_2
    mov cx, 27

comparar:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne no_es_anagrama
    inc si
    inc di
    loop comparar
    
    ; Son anagramas - mostrar en verde
    call cambiar_color_verde
    mov dx, offset msgsiAnagrama
    mov ah, 09h
    int 21h
    call restaurar_color
    
    mov dx, offset salto_linea
    mov ah, 09h
    int 21h
    
    jmp fin_verificacion
    
no_es_anagrama:
    ; No son anagramas - mostrar en rojo
    call cambiar_color_rojo
    mov dx, offset msgnoAnagrama
    mov ah, 09h
    int 21h
    call restaurar_color
    
    mov dx, offset salto_linea
    mov ah, 09h
    int 21h
    
fin_verificacion:
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
verificar_anagrama endp

; Procedimiento para obtener índice de carácter
obtener_indice proc
    push bx
    
    ; Verificar vocales con tilde
    cmp al, 160  ; á
    je es_a
    cmp al, 130  ; é
    je es_e
    cmp al, 161  ; í
    je es_i
    cmp al, 162  ; ó
    je es_o
    cmp al, 163  ; ú
    je es_u
    cmp al, 164  ; ñ
    je es_enie
    
    ; Caracter normal
    sub al, 'a'
    cmp al, 14
    jl indice_ok
    inc al
    jmp indice_ok
    
es_a:
    mov al, 0
    jmp indice_ok
es_e:
    mov al, 4
    jmp indice_ok
es_i:
    mov al, 8
    jmp indice_ok
es_o:
    mov al, 15
    jmp indice_ok
es_u:
    mov al, 20
    jmp indice_ok
es_enie:
    mov al, 14
    
indice_ok:
    pop bx
    ret
obtener_indice endp

; Procedimiento para cambiar color a verde (fondo verde)
cambiar_color_verde proc
    push ax
    push bx
    push cx
    push dx
    
    ; Obtener posición actual del cursor
    mov ah, 03h
    mov bh, 0
    int 10h
    ; DH = fila, DL = columna
    
    ; Limpiar la línea actual con fondo verde
    mov ah, 06h     ; Función scroll
    mov al, 0       ; No hacer scroll
    mov bh, 2Fh     ; Fondo verde + texto blanco
    mov ch, dh      ; Fila inicial = fila actual
    mov cl, 0       ; Columna inicial = 0
    mov dh, dh      ; Fila final = fila actual
    mov dl, 79      ; Columna final = 79
    int 10h
    
    ; Reposicionar cursor al inicio de la línea
    mov ah, 02h
    mov bh, 0
    mov dh, ch      ; Restaurar fila original
    mov dl, 0       ; Columna 0
    int 10h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
cambiar_color_verde endp

; Procedimiento para cambiar color a rojo (fondo rojo)
cambiar_color_rojo proc
    push ax
    push bx
    push cx
    push dx
    
    ; Obtener posición actual del cursor
    mov ah, 03h
    mov bh, 0
    int 10h
    ; DH = fila, DL = columna
    
    ; Limpiar la línea actual con fondo rojo
    mov ah, 06h     ; Función scroll
    mov al, 0       ; No hacer scroll
    mov bh, 4Fh     ; Fondo rojo + texto blanco
    mov ch, dh      ; Fila inicial = fila actual
    mov cl, 0       ; Columna inicial = 0
    mov dh, dh      ; Fila final = fila actual
    mov dl, 79      ; Columna final = 79
    int 10h
    
    ; Reposicionar cursor al inicio de la línea
    mov ah, 02h
    mov bh, 0
    mov dh, ch      ; Restaurar fila original
    mov dl, 0       ; Columna 0
    int 10h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
cambiar_color_rojo endp

; Procedimiento para restaurar color normal
restaurar_color proc
    push ax
    push bx
    
    ; No hacer nada, el color se restaurará automáticamente
    ; cuando se limpie la pantalla o se escriba nuevo texto
    
    pop bx
    pop ax
    ret
restaurar_color endp

end main