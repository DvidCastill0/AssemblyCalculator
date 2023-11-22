.MODEL SMALL
.STACK 128
;--------------------------------------------------------------------------- 
;---------------         Segmento de Datos           -----------------------
;---------------------------------------------------------------------------

.DATA
;Mensajes a mostrar

titulo DB 13,10,'--- Calculadora en ensamblador ---',13,10, 13,10,'|-- David Isaac De la Cruz Castillo --|',13,10,'|-- Victor Leonardo Valle Guerra --|',13,10,'$'
mensajeMenu DB '-1. A + B',13,10, '-2. A - B',13,10, '-3. A * B',13,10, '-4. A / B',13,10, '-5. A ^ B',13,10,'-6. Graficas Trigonometricas',13,10, '-7. Salir',13,10,'$' 
tituloGraf DB 13,10,'--- Selecciona la operacion a graficar ---',13,10, 13,10,'$'
mensajeGraficas DB '-1. Graficar Seno',13,10, '-2. Graficar Coseno',13,10, '-3. Graficar Tangente',13,10, '-4. Todas las anteriores',13,10, '-5. Regresar al menu',13,10,'$'
msjPedirNumero DB 0ah,0dh,'Escribe un numero: ', '$'
msjSaltos DB 0ah,0dh,'',13,10,13,10,13,10, '$' 
msjResultado DB 0ah,0dh, '',13,10,'El resultado de la operacion es: ', '$'
msjFin DB 0ah,0dh, '',13,10,'Gracias por Usar mi programita pongame 100 - :D ',13,10,13,10, '$'
msjSigno DB ' ', '$'
msjSalir DB 'Presione una tecla para continuar...', '$' 
color DB ?
Aux_strNum DB 5 dup(' '), '$'  ;Aux_strNumiliar 
reset DB ' '    ;caracter para reinicio
COUNT DB 0      ;contador de caracteres
COUNT2 DB 0     ;contador de caracteres 
COUNT3 DB 0     ;contador de caracteres

posValues DB 1,10,100             ;Variable para posibles valores a ingresar (3 digitos)
posRes DW 1,10,100, 1000, 10000   ;Variable para posibles valores a retornar (5 digitos)

flagRes DB 0                      ;Variable para no mostrar 0 a la izquierda

Aux_intNum DW 0                   ;Variable auxiliar para manejar valores numericos
op1_intNum DW 0                   ;Variable para operando 1
op2_intNum DW 0                   ;Variable para operando 2 

;Seno
EJEY  DW 225,227,230,232,234,236,238,240,242,244,246,247,249,251,252,253,254,255,256,257,257,258,258,258,258,258,258,258,258,257,257,256,255,254,253,252,251,249,248,246,245,243,241,239,237,235,232,231,229,227,226,224,222,220,218,216,214,211,209,207,206,204,202,201,199,198,197,196,195,194,193,193,192,192,192,192,192,192,192,193,193,194,195,196,197,198,199,201,202,204,205,207,209,211,213,215,218,219,221,223,224
;Coseno 
EJEY2 DW 258,258,258,258,257,257,256,255,254,253,251,250,248,246,245,243,242,240,237,235,233,231,230,228,226,225,224,222,220,218,216,214,211,209,207,206,204,202,201,199,198,197,196,195,194,193,193,192,192,192,192,192,192,192,193,193,194,195,196,197,198,199,201,202,204,205,207,209,211,213,215,218,219,221,223,224,226,228,230,232,234,236,239,241,243,244,246,248,249,251,252,253,254,255,256,257,257,258,258,258,258                                                                                                                                                                                                                                                                     
;Tangente                                                                                                                                                                                                                                                                           
EJEY3 DW 225,227,230,232,234,236,239,242,245,247,251,255,260,265,269,276,283,293,308, 315 ,328,359,396,450,5,15,81,109,133,150,162,172,177,184,189,194,198,201,204,207,209,212,215,217,219,221,223,224,225,226,228,230,233,235,237,240,243,246,248,252,256,261,266,271,278,285,296,312,334,340,350,360,370,380,400,410,450,15,81,109,133,150,162,172,177,184,189,194,198,201,204,207,209,212,215,217,219,221,223,224,225

FLAG DB 0       ;Flag para grtaficar eje Y

COUN DW 0       ;Contador de ejeX
COUN2 DW 450    ;Contador de ejeY     
OPCGrafs DB 0   ;Variable de opciones para graficas

;--------------------------------------------------------------------------- 
;---------------         Segmento de Codigo          -----------------------
;---------------------------------------------------------------------------
.CODE
inicio:
    MOV AX,@data
    MOV DS,AX

menu:
 
 CALL limpiarPantalla
 LEA DX,titulo    ;imprimir el mensajeMenu de titulo de nuestro programa
 MOV AH,9h
 INT 21h
 
 LEA DX,mensajeMenu   ;imprimir mensajeMenu de menu con opciones
 MOV AH,9h
 INT 21h 
 ;--------------------------------------------------------------------------
 ;--------------         Switch de opciones para menu      -----------------
 ;--------------------------------------------------------------------------
 MOV AH,01H             ;pausa y espera a que el usuario precione una tecla
 INT 21h                ;interrupcion para capturar
 CMP AL,49              ; SI la entrada es 1 en ascci 
 JE funcion_Suma        ; brincar a nuestra funcion para hacer Suma
 CMP AL,50              ; SI es un 2
 JE funcion_Resta       ; brincar a nuestra funcion para hacer Division 
 CMP AL,51              ; SI es un 3
 JE funcion_Mul         ; brincar a nuestra funcion para hacer Multiplicacion 
 CMP AL,52              ; SI es un 4
 JE funcion_Div         ; brincar a nuestra funcion para hacer Division 
 CMP AL,53              ; SI es un 5
 JE funcion_Pot         ; brincar a nuestra funcion para hacer Potencia 
 CMP AL,54              ; SI es un 6
 JE funcion_Graficas    ; brincar a nuestra funcion para hacer Graficas 
 CMP AL,55              ; SI es un 7
 JE finPrograma         ; brincar a fin del programa
 CALL hacer3SaltosTexto  
 JMP menu               ; SI es cualquier otra tecla repetir el despliegue en pantalla


 ;--------------------------------------------------------------------------
 ;--------------         Declaracion de funciones          -----------------
 ;--------------------------------------------------------------------------
funcion_Suma:
    CALL seleccionarColor
    CALL pedir2NumUser
    
    MOV AX, op1_intNum  
    ADD AX, op2_intNum
    
    CALL checarSigno
    CALL mostrarResultado
    CALL systemPause     
    CALL hacer3SaltosTexto 
    JMP menu 
    
funcion_Resta:
    CALL seleccionarColor
    CALL pedir2NumUser
    
    MOV AX, op1_intNum
    SUB AX, op2_intNum 
    
    CALL checarSigno
    CALL mostrarResultado
    CALL systemPause     
    CALL hacer3SaltosTexto 
    JMP menu    
    
funcion_Mul:
    CALL seleccionarColor
    CALL pedir2NumUser
    
    MOV AX, op1_intNum
    IMUL op2_intNum 
    
    CALL checarSigno
    CALL mostrarResultado
    CALL systemPause     
    CALL hacer3SaltosTexto 
    JMP menu      
    
funcion_Div:
    CALL seleccionarColor
    CALL pedir2NumUser
    
    MOV AX, op1_intNum
    IDIV op2_intNum 
    
    CALL checarSigno
    CALL mostrarResultado
    CALL systemPause     
    CALL hacer3SaltosTexto 
    JMP menu     
    
funcion_Pot:
    CALL seleccionarColor
    CALL pedir2NumUser
    
    MOV AX, 1
    MOV CX, op2_intNum    
    
    potenciar:
        MUL op1_intNum
        loop potenciar  
            
    CALL checarSigno
    CALL mostrarResultado
    CALL systemPause 
    CALL systemPause     
    CALL hacer3SaltosTexto 
    JMP menu                  

    
finPrograma: 
    CALL hacer3SaltosTexto 
    MOV AH,09
    MOV DX,offset msjFin            ;Imprime mensajeMenu  de fin de programa
    INT 21h
    MOV AH,04ch                     ;Terminamos programa con INT21H
    INT 21h
    

funcion_Graficas:
    CALL limpiarPantalla
    LEA DX,tituloGraf    ;imprimir el titulo de la seccion de graficas
    MOV AH,9h
    INT 21h
     
    LEA DX,mensajeGraficas   ;imprimir mensajeMenu de menu con opciones  para graficas
    MOV AH,9h
    INT 21h   
    
     ;--------------------------------------------------------------------------
     ;--------------       Switch de opciones para Graficas   ------------------
     ;--------------------------------------------------------------------------
     MOV AH,01H             ;pausa y espera a que el usuario precione una tecla
     INT 21h                ;interrupcion para capturar
     MOV OPCGrafs, AL
     CMP AL, 49             ; SI es un 1
     JZ  llamarGraficas
     CMP AL, 50             ; SI es un 2
     JZ  llamarGraficas
     CMP AL, 51             ; SI es un 3
     JZ  llamarGraficas
     CMP AL, 52             ; SI es un 4
     JZ  llamarGraficas
     CMP AL,53              ; SI es un 5
     JE salir_Graficas      ; brincar a nuestra funcion para hacer Potencia 
     
     
     regresoGraficas:
     CALL systemPause     
     CALL hacer3SaltosTexto 
     MOV AH, 0
     mov aL,03h	;Funcion para regresar a modo de texto
     int 10h 	 ;Llamamos a la INT 10h
     JMP funcion_Graficas               ; SI es cualquier otra tecla repetir el despliegue en pantalla    

    llamarGraficas:
        CALL graficarTrigo
        JMP regresoGraficas     
    
salir_Graficas: 
    JMP menu        
    
           

 ;--------------------------------------------------------------------------
 ;----------         Funcion para pedir numeros al usuario     -------------
 ;--------------------------------------------------------------------------             

pedirNumero PROC NEAR     
    
    CALL limpiarVariables
    
            
    MOV AH,09
    MOV DX,offset msjPedirNumero    ;Imprimimos el msjPedirNumero
    INT 21h  
    
    LEA SI,Aux_strNum               ;Cargamos en el registro SI AL primer Aux_strNumiliar
    getNumbers:
        INC COUNT                   ;Incrementamos contador por cada caracter ingresado
        MOV AH,01h                  ;Pedimos un caracter
        INT 21h
        MOV [SI],AL                 ;Se guarda en el registro indexado AL Aux_strNumtor
        INC SI
        CMP AL,0Dh                  ;Se cicla hasta que se digite un Enter
        JZ salirGetNumbersEnter
        CMP COUNT,03H               ;o se hayan ingresado 3 caracteres
        JZ salirGetNumbers  
        
    JMP getNumbers                  ;SI no, se seguira ciclando
    
    salirGetNumbersEnter:          
              DEC COUNT             ;Si se presiono enter decrementamos el contador para no leer el enter
    salirGetNumbers:           
        MOV AX, 0 
        MOV BX, 0     
        MOV CX, 0
        MOV DX, 0 
        
        LEA SI,Aux_strNum       ;cargamos en SI la cadena que contiene vec
        MOV AH,0 
        MOV AL,[SI]+BX          ;Obtenemos caracter de la derecha
        CMP AL, 2DH             ;Checamos si es un guion bajo es decir un negativo
        JZ esNegativo?        ;Si si es convertimos el numero a complemento a 2
        MOV AX, 0               ;Sino regresamos los valores a predeterminado
        MOV BX, 0  
        
        getValues:                  ;Obtenemos valor de cada caracter
            LEA SI,Aux_strNum       ;cargamos en SI la cadena que contiene vec
            MOV AH,0 
            MOV AL,[SI]+BX          ;Obtenemos caracter de la derecha
            SUB AL,30H              ;Le restamos 30 para obtener su valor decimal
            DEC COUNT
            MOV DL, COUNT  
            MOV SI, DX 
            MOV CH, 0
            MOV CL, posValues[SI]   ;Se obtiene su valor segun la posicion (Desenas, centenas, etc)
            MUL CX                  ;Se multiplica el caracter por su respectivo valor de posicion
            ADD Aux_intNum, AX      ;Se va sumando los valores a nuestra variable auxiliar
            INC BX
            CMP COUNT,0H            ;Ciclamos segun al cantidad de caracteres ingresados
            JZ salir              
            JMP getValues
            
    salir:
        CMP flagRes, 1              ;Checamos si el numero ingresado es negativo
        JZ  hacerNegativo           ;Si si es se hace negativo
        RET                         ;sino, regresamos el procedimiento de donde lo llamaron.

    esNegativo?:
        MOV flagRes, 1 
        DEC COUNT
        INC BX
        JMP getValues 
    hacerNegativo:
         MOV AX,Aux_intNum
         NEG AX                     ;Ponemos el numero en complemento a 2
         MOV Aux_intNum, AX 
         RET
pedirNumero ENDP  


 ;--------------------------------------------------------------------------
 ;----------       Reiniciamos nuestras variables              -------------
 ;--------------------------------------------------------------------------
limpiarVariables PROC NEAR 
    
    MOV COUNT, 0 
    MOV COUNT2, 0
    MOV COUNT3, 0
    MOV flagRes, 0
    MOV Aux_intNum, 0
    reinicioAux:                    ;Reiniciar el auxiliar de caracteres
                MOV CX, 5           ;Caracteres a limpiar
                LEA BX, Aux_strNum
                MOV DL, reset
    
    reinicioChar:
                MOV [BX], DL        ;Sustitur caracteres por espacios
                INC BX
                loop reinicioChar 
                        
        RET                         ;regresamos el procedimiento de donde lo llamaron.
limpiarVariables ENDP       


 ;--------------------------------------------------------------------------
 ;----------       Convertimos de Decimal a ASCCI              -------------
 ;--------------------------------------------------------------------------
mostrarResultado PROC NEAR          
CALL limpiarVariables
CMP   AX, 0
JZ    ponerCero

MOV COUNT2, 8               ;Obtenemos el valor para el caracter 5 de nuestro resultado (10000)
Division:
     MOV DH, 0
     MOV DL, COUNT2
     MOV SI, DX
     MOV DX, 0
     MOV CX, posRes[SI]     ;Obtenemos el valor segun la posicion
     SUB COUNT2, 2 
     MOV Aux_intNum, AX     ;Creamos una copia del valor actual
     DIV CX                 ;Dividimos entre el valor segun la posicion (Descenas, centenas, etc)
     
     CMP AX, 0              ;SI no cabe la division pasar a la siguiente
     JZ evaluarBandera  
     
     MOV flagRes, 1         ;Si si cabe pasar a ASCCI el valor

actualizarElementos:         
     ADD AL, 30H            ;Restamos el correspondiente a ASCCI del valor obtenido
     MOV CX, 0
     MOV CL, COUNT3 
     MOV SI, CX
     MOV Aux_strNum[SI], AL ;Ponemos el valor ASCCI en la posicion correspondiente
     MOV AX, DX             ;Pasamos el residuo de la division a AX
     INC COUNT3
     INC COUNT
     CMP COUNT, 5           ;Comparamos si se han comparado las 5 posibles posiciones o digitos
     JZ salirMostrarRes     ;Si es asi salimos
     JMP Division           ;Sino repetimos el proceso
     
evaluarBandera:             
     CMP flagRes, 0         ;Evaluamos si  se ha ingresado un caracter anteriormente
     JZ  siguienteIteracion ;Si no es asi, pasamos a la siguiente iteracion
     JMP actualizarElementos ;Si si es asi pasar a ASCCI el valor

siguienteIteracion:
         MOV AX, Aux_intNum ;Asignamos a AX el valor que tenia antes de la division
         INC COUNT
         CMP COUNT, 5       ;Se checa que se hayan comparado los 5 caracteres
         JZ salirMostrarRes ;Si si es asi salimos de la funcion
         JMP Division       ;Si no, repetimos el bucle


 
                            
salirMostrarRes:            ;Salimos de la funcion y mostramos el resultado

        MOV AH,09
        MOV DX,offset msjResultado  ;Imprime mensaje de Resultado  
        INT 21h
        MOV AH, 03H                 ; Obtener cursor
        MOV BH, 0
        INT 10H
        LEA SI, color               ; Cargar color
        MOV BL, color
        MOV CX, 1
        MOV AL, msjSigno[0]         ; Cargar signo
        MOV AH, 09H
        INT 10H                     ; Imprimir signo
        INC DL
        MOV AH, 02H                 ; Recolocar cursor
        INT 10H
        MOV SI, 0
imprimirResultado:        
        MOV AL, Aux_strNum[SI]      ; Cargar resultado  
        MOV AH, 09H
        INT 10h                     ; Imprimir resultado
        INC SI
        INC DL
        MOV AH, 02H                 ; Recolocar cursor
        INT 10H
        CMP SI, 5                   
        JL imprimirResultado        ; Repetir por cada caracter
        RET     

ponerCero:
       MOV Aux_strNum[0], 48 
       JMP salirMostrarRes

mostrarResultado ENDP  


 
 ;--------------------------------------------------------------------------
 ;----------       Realizamos 3 saltos de linea                -------------
 ;--------------------------------------------------------------------------
hacer3SaltosTexto PROC NEAR 
        MOV AH,09
        MOV DX,offset msjSaltos ;Imprime mensaje con saltos de linea
        INT 21h                  
        RET                     ;regresamos el procedimiento de donde lo llamaron.
hacer3SaltosTexto ENDP 

 ;--------------------------------------------------------------------------
 ;----------                   Limpiar Pantalla                -------------
 ;--------------------------------------------------------------------------
limpiarPantalla PROC NEAR 
     MOV AH, 0FH             ;Limpiamos pantalla
     INT 10H
     MOV AH, 0               ;Posicionamos cursor
     INT 10H                  
     RET                     ;regresamos el procedimiento de donde lo llamaron.
limpiarPantalla ENDP 

 ;--------------------------------------------------------------------------
 ;----------                   pausa                           -------------
 ;--------------------------------------------------------------------------
systemPause PROC NEAR 
 LEA DX, msjSalir       ;mostrar mensaje para continuar
 MOV AH,9h
 INT 21h  
 MOV AH,01H             ;pausa y espera a que el usuario precione una tecla
 INT 21h                ;interrupcion para capturar
 RET
systemPause ENDP 

 ;--------------------------------------------------------------------------
 ;-----     Llamamos a procedimientos, para pedir 2 numeros      -----------
 ;--------------------------------------------------------------------------
pedir2NumUser PROC NEAR 
        ;MOV AH,01h             ;Esperar tecla (Para rellenar buffer de memoria)
        ;INT 21h
        CALL hacer3SaltosTexto
        CALL pedirNumero
        MOV AX,Aux_intNum
        MOV op1_intNum, AX      ; Obtenemos el valor del operando 1
        CALL pedirNumero
        MOV AX,Aux_intNum
        MOV op2_intNum, AX      ; Obtenemos el valor del operando 2                  
        RET                     ;regresamos el procedimiento de donde lo llamaron.
pedir2NumUser ENDP 


 ;--------------------------------------------------------------------------
 ;-----              Checar signo de numero                      -----------
 ;--------------------------------------------------------------------------
checarSigno PROC NEAR 
        MOV BX, AX
        SAL AX, 1     ;Esta activado el bit 16 del registro 'AX'?
        JC Negativo
          MOV AX, BX
          MOV msjSigno[0], ' '
          RET
        Negativo:
          MOV AX, BX
          MOV msjSigno[0], '-'
          CALL compl2ADec   
          RET                     ;regresamos el procedimiento de donde lo llamaron.
checarSigno ENDP 

 ;--------------------------------------------------------------------------
 ;-----              Comlemento  2 a Decimal                     -----------
 ;--------------------------------------------------------------------------
compl2ADec PROC NEAR 
        SUB AX, 1               ;Restamos 1 para hacer proc inverso de Comp a 2
        NOT AX                  ;Not 
        RET                     ;regresamos el procedimiento de donde lo llamaron.
compl2ADec ENDP  


;--------------------------------------------------------------------------
;-----           seleccionar Color para mostrar Resul           -----------
;--------------------------------------------------------------------------
seleccionarColor PROC NEAR
        SUB AX, 48              ;Se asigna un color restando a lo escogido
        LEA SI, color           ;48 y ese sera el color a mostrar
        MOV [SI], AL            ;Variando segun la opcion
        RET
seleccionarColor ENDP
        

;--------------------------------------------------------------------------
;-----           Graficar funciones trigonmetricas              -----------
;--------------------------------------------------------------------------

graficarTrigo PROC NEAR  
   
PIXEL MACRO        ;Macro para pintar graficas por puntos
   MOV AL, 1111B   ; Color Blanco
   mov ah, 0ch     ; pone pixel
   int 10h
ENDM    

MOV AX, 0          ;Vaciamos los registros
MOV BX, 0
MOV CX, 0
MOV DX, 0
MOV COUN, 0       ;Inicializamos los contadores
MOV COUN2, 450   
mov ah, 00      ; Preparar int 10 para video
mov al, 12h     ; configurar la pantalla a 640*400 
int 10h   

MOV CX, 0       ;Inicializamos el loop
            
;Realizar Curva Postiva    
NEXTP:  
INC CX          ;Incremento de loop      
MOV DX, 225     ; Poner el cero del eje X
PIXEL           ; dibujar el pixel del cero


CMP FLAG, 1           ;Checar si ya se dibujo el EJE Y 0
JZ  continuarNormal   ;Si si saltar el dibujarlo
CMP CX, 306           ;Si no checar ahora si estamos a la mitad de la grafica
JZ  imprimir0Y        ;Dibujar Eje de Y en 0

continuarNormal:
CMP COUN, 202         ;Si el contador recorrio todo el arreglo
JZ  resetCOUN         ;Reiniciarlo a 0

CMP OPCGrafs, 49      ;si se presiono 1 en el menu grafico
JZ graficarSen        ;Mostrar grafica de seno

CMP OPCGrafs, 50      ;Si se preisono 2
JZ graficarCos        ;Mostrar grafica coseno

CMP OPCGrafs, 51      ;Si se presiono 3
JZ graficarTan        ;Mostrar Tangente

CMP OPCGrafs, 52      ;Si se presiono 4
JZ graficarTodas      ;Mostrar las 3 graficas juntas



continuarGrafi:    

    ADD COUN, 2       ;Anadimos 2 al contador ya que manejamos registros de 2 bytes


continuar:
                
   CMP CX, 640        ; Si ya llegamos al ancho total
   JZ FIN             ;Terminamos de graficar
   JMP NEXTP          ; Sino seguimos imprimiendo pixeles  

resetCOUN:            ;Reinicia el contador a 0
   MOV COUN, 0
   JMP continuar           

imprimir0Y:           ; Dibujamos eje de Y para 0
   MOV FLAG, 1        ; indica que se dibujo el eje de Y
   DEC COUN2
   CMP COUN2, 0
   JZ  continuarNormal
   MOV DH, 0
   MOV DX, COUN2      ; Recorremos contador de 0 a 450
   PIXEL 
   JMP imprimir0Y              
FIN:
   RET                ;Acabamos el procedimiento
   


graficarSen:  
    CALL GrafSeno       ;Imprimimos seno
    JMP continuarGrafi
    
graficarCos:
    CALL GrafCos        ;Imprimimos Coseno
    JMP continuarGrafi 
    
graficarTan:         
    CALL GrafTan        ;Imprimimos Tangente
    JMP continuarGrafi 

graficarTodas:          ;Imprimimos todas las graficas
    CALL GrafSeno 
    CALL GrafCos
    CALL GrafTan
    JMP continuarGrafi 
   
   
graficarTrigo  ENDP 


GrafSeno PROC NEAR 
    MOV SI, COUN      ; Pasar el indice  desde el Count   
    MOV DH, 0  
    MOV DX, 450
    SUB DX, EJEY[SI]  ; en DX la posicion del arreglo de entre 0 a 101
    PIXEL 
    RET
GrafSeno  ENDP


GrafCos PROC NEAR 
    MOV SI, COUN      ; Pasar el indice  desde el Count   
    MOV DH, 0  
    MOV DX, 450
    SUB DX, EJEY2[SI]  ; en DX la posicion del arreglo de entre 0 a 101
    PIXEL     
    RET
GrafCos  ENDP  

GrafTan PROC NEAR 
    MOV SI, COUN      ; Pasar el indice  desde el Count  
    MOV DH, 0  
    MOV DX, 450
    SUB DX, EJEY3[SI] ; en DX la posicion del arreglo de entre 0 a 101
    PIXEL
    RET
GrafTan  ENDP 


END     ;Terminamos programa  


