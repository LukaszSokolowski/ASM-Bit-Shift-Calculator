ORG 100H

;Mnozenie i dzielenie za pomoca przesuniec bitowych
;Pobieramy dwie liczby i wykonujemy dzialania 
;a oraz b gdzie a to liczba dziesietna z zakresu 16 bit, b to liczba od 1 do 16
;przy dzieleniu a/b liczba b musi byc potęgą liczby 2

    start:
            CALL hello
    reset:
            CALL inform1
            CALL getNum
            CALL set1

            CALL inform2
            CALL getNum
            CALL set2

            CALL inform3
            CALL getOper        ;Wybierz operator, opr = * lub opr = / lub opr = :
            CALL checkNum          ;Sprawdz czy spelniaja wymagania
                         
            CALL doOperat       ;Wykonaj operacje








            ;CALL showRes


         
    koniec:
            MOV AX, 4C00H
            INT 21H
;-----------------------Zmienne----------------------------------
info db "Witaj w programie przesuniec bitowych.$"
info0 db "Podaj pierwsza liczbe: $"
info1 db "Podaj druga liczbe: $"
info2 db "Jesli chcesz pomnozyc podaj znak mnozenia (*) a jesli podzielic wpisz (/)$"
info3 db "Koniec programu. $"
info4 db "Bledne wprowadzenie. $"
ent1  db 10,13,36

adr_init   dw 0
st_count  db 0
digit    dw 0
mnoznik  dw 1
temp   dw 0
liczba1  dw 0
liczba2  dw 0
opr   db  0

result dw 0
;-----------------------------Hello----------------------------
hello:
             MOV AH, 9
            MOV DX, info
            INT 21H
RET
;----------------------------First-input-------------------------
inform1:
      
            MOV DX, ent1
            INT 21H

            MOV DX, info0
            INT 21H
RET
;---------------------------Second-input-------------------------
inform2:
            MOV AH, 9
            MOV DX, info1
            INT 21H
RET
;--------------------------Operation-input------------------------
inform3:
            MOV AH, 9
            MOV DX, ent1
            INT 21H

            MOV DX, info2
            INT 21H
RET
 ;------------------------Wczytanie-liczb--------------------------

 getNum:
        POP AX              ;Zrzuc adres powrotu
    MOV [adr_init], AX      ;Przenies adres do AX
    MOV CX, 0           ;Wyzeruj licznik
    
    pushloop:
            MOV AH, 1       ;Wczytanie znaku z wejscia
            INT 21H         ;Przerwanie DOS
        
            CMP AL, 13      ;Porownaj czy enter
            JE poploop      ;Jesli tak przejdz do zrzucania
        
            CMP AL, 48      ;Sprawdz czy mniejsze od cyfr w ascii
            JL _error       ;Jesli tak to koniec
            
            CMP AL, 57      ;Sprawdz czy wieksze od znakow cyfr ascii
            JG _error       ;Jesli tak to koniec
 
            INC CX          ;Mamy cyfre wiec zwieksz CX
            MOV [st_count], CX  ;Przenies do zmiennej przechowujacej ilosc liczb na stosie wartosc CX
                
            SUB  AL, 48     ;Odejmij od znaku 48 tak aby uzyskac odpowiadajaca jemu cyfre
            XOR  AH, AH     ;Wyzeruj gore rejestru AX
            PUSH AX         ;Wrzuc AX na stos

            JMP pushloop        ;Kolejny krok petli
        
       poploop:

            POP BX          ;Zdejm cyfre ze stosu
            XOR BH, BH      ;Wyzeruj gore rejestru BX
            MOV [digit], BX     ;Przenies cufre do zmiennej
        
            XOR AX, AX      ;Wyzeruj AX 
            MOV AX, [mnoznik]   ;Przenies do AX wartosc mnoznika
            MUL BX          ;Pomnoz AX razy BX wynik w DX:AX
        
            ADD [temp], AX      ;Dodaj do zmiennej tymczasowej kolejna wartosc
        
            MOV BX, 10      ;Zaladuj rejestr BX wartoscia 10
            XOR BH, BH      ;Wyzeruj gore BX
            MOV AX, [mnoznik]   ;Przenies do AX wartosc mnoznika
            MUL BX          ;Z kazdym kolejnym zdjeciem ze stosu mnoznik wzrasta x 10 
            MOV [mnoznik], AX   ;Przenies mnoznik do zmiennej 
    
            loop poploop        ;Wykonuj petle

                MOV AX, [adr_init]      ;Przenies do AX adres powrotu procedury
        PUSH AX             ;Wrzuc adres powrotu na stos
        XOR AX, AX      ;Wyzeruj AX
        MOV AX, 1       ;Przenies do AX wartosc poczatkowa mnoznika
        MOV [mnoznik], AX   ;Do zmiennej mnoznik przenies jego wartosc poczatkowa
        XOR AX, AX      ;Wyzeruj AX
        XOR BX, BX      ;Wyzeruj BX
        
  RET
;---------------------------CLEAR-temp-1----------------------------
  set1:

                MOV  AX,        [temp]      ;Przenies do AX zmienna tymczasowa
                MOV  [liczba1], AX      ;Przydziel wartosc zmiennej temp do zmiennej liczba1
                XOR  AX,        AX      ;Wyczysc AX
                MOV  [temp],    AX      ;Wyczysc temp

  RET
;---------------------------CLEAR-temp-2----------------------------  
  set2:      

                MOV  AX,        [temp]      ;Wartosc zmiennej tymczasowej do AX
                MOV  [liczba2], AX      ;Zmienna liczba2 ma wartosc zmiennej tymczasowej
                XOR  AX,        AX      ;Wyczysc AX
                MOV  [temp],    AX      ;Wyczysc zmienna temp

 RET
 ;------------------------------Bledy-wprowadzenia------------------------------------
 _error:
        XOR AX, AX
        MOV AH, 9
        MOV  DX, ent1       ;Przenies do DX adres zmiennej ent1
        INT 21H
   
        MOV  DX, info4      ;Przenies adres zmiennej info3
        INT 21H

        JMP reset           ;Bezwarunkowo przejdz do etykiety start 

;--------------------------Wyswietl-wynik-----------------------------
showRes:
    POP AX              ;Zdejmij ze stosu adres powrotu
    MOV [adr_init], AX  ;Przenies adres powrotu do zmiennej

        XOR AX, AX      ;Wyczysc AX
        XOR BX, BX      ;Wyczysc BX
        XOR CX, CX      ;Wyczysc CX
        XOR DX, DX      ;Wyczysc DX

        MOV AX, [result];Przenies do AX wynik operacji
        MOV CX, 0       ;Przenies 0 do CX
        MOV BX, 10      ;Przenies dzielnik do BX
    
             pushwyni:
                XOR DX, DX  ;Wyzeruj DX
                    DIV BX      ;Podziel AX przez BX
                    PUSH DX     ;Wrzuc reszte
                INC CX      ;Zwieksz licznik
                CMP AX, 0   ;Porownaj czy licznik rowny 0
                JA pushwyni ;Jesli wiekszy dziel dalej


                    MOV AH, 2   ;Wypisz znak

            echow:
                POP DX      ;Zrzuc do DX
                XOR DH, DH  ;Zeruj gore rejestru DX czyli DH
                ADD DX, 48  ;Dodaj 48 tak aby wyswietlic cyfre
                INT 21H     ;Przerwanie DOS
                loop echow  


    MOV  AX, [adr_init]
    PUSH AX
RET 
;-----------------------Wybor-operacji---------------------------------
getOper:
        
    MOV AH, 1       ;Czytaj znak z wejscia
    INT 21H         ;Przerwanie DOS

    CMP AL, '*'     ;Czy uzytkownik chce pomnozyc te liczby?
    JE  _mul        ;Jesli tak to przejdz do etykiety mnozenia

    CMP AL, '/'     ;Czy uzytkownik chce podzielic te liczby?
    JE  _div        ;Jesli tak przejdz do etykiety dzielenia
        
    CMP AL, ':'     ;Rowniez symbol dzielenia
    JE  _div        ;Przejdz do dzielenia jesli rowne

    JMP _error      ;Jesli znak spoza zakresu wyrzuc wyjatek

    _mul:
            MOV [opr], AL
            JMP endOper

    _div:
            MOV [opr], AL

    endOper:    

    XOR BX, BX          ;Wyczysc BX
    XOR AX, AX          ;Wyczysc AX
    XOR DX, DX          ;Wyczysc DX

RET
;-----------------------------------------------------
checkNum:
        XOR AX, AX
        MOV AL, [opr]

        CMP AL, '*'
        JE xMul

        CMP AL, '/'
        JE xDiv
       
        CMP AL, ':'
        JE xDiv

        xDiv:               ; Przy dzieleniu liczba2 to potega dwojki oraz z zakresu od 1 do 16

            XOR AX, AX
            MOV AX, [liczba2]

            CMP AX, 1
            JL  _error

            CMP AX, 16
            JG _error

            CMP AX, 2
            JE  endCheck

            CMP AX, 4
            JE  endCheck

            CMP AX, 8
            JE  endCheck

            CMP AX, 16
            JE  endCheck

            JMP _error

        xMul:               ;Przy mnozeniu to liczba2 od 1 do 16

            XOR AX, AX
            MOV AX, [liczba2]

            CMP AX, 1
            JL  _error

            CMP AX, 16
            JG _error

            JMP endCheck

    endCheck:

RET
;-------------------------Wykonaj-dzialania-----------------------
doOperat:
            XOR AX, AX
            MOV AL, [opr]

            CMP AL, '*'
            JE multiply

            CMP AL, '/'
            JE divide

            CMP AL, ':'
            JE divide


            divide:


            JMP endProc




            multiply:


            JMP endProc


endProc:

RET
;----------------------------------------------------------------