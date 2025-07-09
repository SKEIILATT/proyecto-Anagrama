# Anagrama en Ensamblador MASM

## Autores

* Javier Gutierrez
* Juan Munizaga

## Descripción

Este proyecto es una utilidad en ensamblador (MASM/TASM, modelo `small`) que permite determinar si dos cadenas de texto (palabras o frases) son anagramas, ignorando espacios y sin distinguir mayúsculas/minúsculas. Incluye además:

* Eliminación de espacios antes del análisis.
* Conversión de letras mayúsculas a minúsculas.
* Soporte de letras acentuadas (`á, é, í, ó, ú`) y la letra `ñ`.
* Bucle principal que permite repetir el proceso hasta que el usuario decida salir.
* Salidas coloreadas: verde si son anagrama, rojo si no.

## Características principales

1. **Lectura de cadenas** – Dos buffers de hasta 45 caracteres cada uno.
2. **Procesamiento** – Llamadas a procedimientos:

   * `limpiar_contadores` – Reinicia los contadores de frecuencia.
   * `procesar_palabra1` / `procesar_palabra2` – Quita espacios y convierte a minúsculas.
   * `verificar_anagrama` – Cuenta frecuencias y compara.
3. **Color en pantalla** – Uso de interrupciones BIOS (`INT 10h AH=0Eh`) para texto en verde o rojo.
4. **Flujo de control** – Etiqueta `start_loop` y pregunta `Desea continuar? (S/N):`.

## Archivos del proyecto

* `anagrama.asm` – Código fuente en ensamblador.
* `README.md` – Este documento.

## Uso

1. Al iniciar, el programa solicita:

   * "Ingrese la primera palabra o frase a analizar:"
   * "Ingrese la segunda palabra o frase a analizar:"
2. Después del análisis, muestra:

   * **"Son anagrama"** en color **verde** si aplicable.
   * **"No son anagrama"** en color **rojo** en caso contrario.
3. Pregunta "Desea continuar? (S/N):" para repetir o salir.
