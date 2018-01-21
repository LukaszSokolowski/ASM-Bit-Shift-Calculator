ORG 100H

;Mnozenie i dzielenie za pomoca przesuniec bitowych
;Pobieramy dwie liczby i wykonujemy dzialania 
;a oraz b gdzie a to liczba dziesietna z zakresu 16 bit, b to liczba od 1 do 16
;przy dzieleniu a/b liczba b musi byc potęgą liczby 2

    start:
            CALL hello           ;Procedura wywolujaca powitanie
    reset:  
            CALL inform1         ;Pokaz informacje dla uzytkownika
            CALL getNum          ;Pobierz pierwsza liczbe
            CALL set1            ;Ustaw zmienna dla pierwszej liczby

            CALL inform2         ;Informacja dla uzytkownika
            CALL getNum          ;Pobierz druga liczbe
            CALL set2            ;Ustaw druga liczbe

            CALL inform3         ;Informacja dla uzytkownika
            CALL getOper         ;Wybierz operator, opr = * lub opr = / lub opr = :
            CALL checkNum        ;Sprawdz czy spelniaja wymagania
                         
            CALL doOperat        ;Wykonaj operacje zadana przez uzytkownika

            CALL showRes         ;Wyswietl wynik dzialania
                

;-----------------------Koniec-programu-------------------------         
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
info5 db "Wynik operacji to: $"
ent1  db 10,13,36

adr_init   dw 0
st_count   db 0
digit      dw 0
mnoznik    dw 1
temp       dw 0
liczba1    dw 0
liczba2    dw 0
opr        db 0
result     dw 0
;-----------------------------Hello----------------------------
hello:
            MOV AH, 9          ;Kopiuj do rejestru AH wartosc odpowiadajaca funkcji wyswietlenia lancucha znakow
            MOV DX, info       ;Przenies adres do DX
            INT 21H            ;Przerwanie DOS 
RET
;----------------------------First-input-------------------------
inform1:
            MOV DX, ent1      ;Przenies adres do DX
            INT 21H           ;Przerwanie DOS

            MOV DX, info0     ;Przenies adres do DX
            INT 21H           ;Przerwanie DOS
RET
;---------------------------Second-input-------------------------
inform2:
            MOV AH, 9           ;Kopiuj do rejestru AH wartosc odpowiadajaca funkcji wyswietlenia lancucha znakow
            MOV DX, info1       ;Przenies adres do DX
            INT 21H             ;Przerwanie DOS
RET
;--------------------------Operation-input------------------------
inform3:
            MOV AH, 9            ;Kopiuj do rejestru AH wartosc odpowiadajaca funkcji wyswietlenia lancucha znako
            MOV DX, ent1         ;Przenies adres do DX
            INT 21H              ;Przerwanie DOS

            MOV DX, info2        ;Przenies adres do DX
            INT 21H              ;Wywolaj przerwanie DOS
RET
 ;------------------------Wczytanie-liczb--------------------------
 getNum:
        POP AX              ;Zrzuc adres powrotu
    MOV [adr_init], AX      ;Przenies adres do AX
    MOV CX, 0               ;Wyzeruj licznik
    
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

            JMP pushloop    ;Kolejny krok petli
        
       poploop:

            POP BX              ;Zdejm cyfre ze stosu
            XOR BH, BH          ;Wyzeruj gore rejestru BX
            MOV [digit], BX     ;Przenies cufre do zmiennej
        
            XOR AX, AX          ;Wyzeruj AX 
            MOV AX, [mnoznik]   ;Przenies do AX wartosc mnoznika
            MUL BX              ;Pomnoz AX razy BX wynik w DX:AX
        
            ADD [temp], AX      ;Dodaj do zmiennej tymczasowej kolejna wartosc
        
            MOV BX, 10          ;Zaladuj rejestr BX wartoscia 10
            XOR BH, BH          ;Wyzeruj gore BX
            MOV AX, [mnoznik]   ;Przenies do AX wartosc mnoznika
            MUL BX              ;Z kazdym kolejnym zdjeciem ze stosu mnoznik wzrasta x 10 
            MOV [mnoznik], AX   ;Przenies mnoznik do zmiennej 
    
            loop poploop        ;Wykonuj petle

                MOV AX, [adr_init]      ;Przenies do AX adres powrotu procedury
        PUSH AX                         ;Wrzuc adres powrotu na stos
        XOR AX, AX     		        ;Wyzeruj AX
        MOV AX, 1       		;Przenies do AX wartosc poczatkowa mnoznika
        MOV [mnoznik], AX 	 	;Do zmiennej mnoznik przenies jego wartosc poczatkowa
        XOR AX, AX      		;Wyzeruj AX
        XOR BX, BX      		;Wyzeruj BX
        
  RET
;---------------------------CLEAR-temp-1----------------------------
  set1:
                MOV  AX,        [temp]  ;Przenies do AX zmienna tymczasowa
                MOV  [liczba1], AX      ;Przydziel wartosc zmiennej temp do zmiennej liczba1
                XOR  AX,        AX      ;Wyczysc AX
                MOV  [temp],    AX      ;Wyczysc temp

  RET
;---------------------------CLEAR-temp-2----------------------------  
  set2:      
                MOV  AX,        [temp]  ;Wartosc zmiennej tymczasowej do AX
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

                MOV AH, 9       ;Wyswietl lancuch
                MOV DX, ent1    ;Adres zmiennej do DX
                INT 21H         ;Przerwanie DOS

                MOV DX, info5   ;Adres zmiennej do DX
                INT 21H         ;Wywolaj przerwanie DOS

                MOV AH, 2   ;Wypisz znak

            echow:
                POP DX      ;Zrzuc do DX
                XOR DH, DH  ;Zeruj gore rejestru DX czyli DH
                ADD DX, 48  ;Dodaj 48 tak aby wyswietlic cyfre
                INT 21H     ;Przerwanie DOS
                loop echow  


            XOR AX, AX

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
            MOV [opr], AL        ;Przenies do zmiennej wartosc rejestru AL
            JMP endOper          ;Przeskocz bezwarunkowo do etykiety konca procedury

    _div:
            MOV [opr], AL       ;Przenies do zmiennej wartosc spod rejestru AL

    endOper:    

    XOR BX, BX          ;Wyczysc BX
    XOR AX, AX          ;Wyczysc AX
    XOR DX, DX          ;Wyczysc DX

RET
;-----------------------------------------------------
checkNum:
        XOR AX, AX            ;Wyczysc AX
        MOV AL, [opr]         ;Kopiuj do AL wartosc zmiennej operatora

        CMP AL, '*'           ;Porownaj ze znakiem mnozenia
        JE xMul               ;Jesli rowne to przejdz do etykiety xMul

        CMP AL, '/'           ;Porownaj ze znakiem dzielenia
        JE xDiv               ;Jesli rowne to przejdz do etykiety xDiv
       
        CMP AL, ':'           ;Porowmaj ze znakiem dzielenia
        JE xDiv               ;Jesli rowne to przejdz do etykiety xDiv

        xDiv:                 ;Przy dzieleniu liczba2 to potega dwojki oraz z zakresu od 1 do 16

            XOR AX, AX        ;Wyczysc AX
            MOV AX, [liczba2] ;Przenies do AX wartosc drugiej wprowadzonej liczby

            CMP AX, 1         ;Porownaj z wartoscia 1
            JL  _error        ;Jesli mniejsze to przejdz do etykiety bledu

            CMP AX, 16        ;Porownaj z wartoscia 16 
            JG _error         ;Jesli wieksze to przejdz do etykiety bledow

            CMP AX, 2         ;Porownaj z 2
            JE  endCheck      ;Jesli rowne to wartosc dopuszczalna

            CMP AX, 4         ;Porownaj z 4
            JE  endCheck      ;Jesli rowne to wartosc dopuszczalna

            CMP AX, 8         ;Porownaj z 8
            JE  endCheck      ;Jesli rowne to wartosc dopuszczalna

            CMP AX, 16        ;Porownaj z 16
            JE  endCheck      ;Jesli rowne to wartosc dopuszczalna

            JMP _error

        xMul:                     

            XOR AX, AX              ;Wyczysc AX
            MOV AX, [liczba2]       ;Przenies do AX, wartosc zmiennej liczba2

            CMP AX, 1               ;Porownaj z jedynka 
            JL  _error              ;Jesli mniejsze to blad

            CMP AX, 16              ;Porownaj z 16
            JG _error               ;Jesli mniejsze to przekracza zalozenia

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

;Ponizej obliczam wartosci przesuniec dla poszczegolnych przypadkow 
;wprowadzonych liczb przez uzytkownika oraz wykonuje
;odpowiednie dzialania matematyczne w zaleznosci od wyboru uzytkownika

            divide:
                    XOR AX, AX
                    XOR BX, BX
                    MOV AX, [liczba1]      
                    MOV BX, [liczba2]       

                    CMP BX, 2
                    JE shr1

                    CMP BX, 4
                    JE shr2

                    CMP BX, 8
                    JE shr3

                    CMP BX, 16
                    JE shr4

                    shr1:
                            SHR AX, 1
                            MOV [result], AX
                            JMP endProc
                    shr2:
                            SHR AX, 2
                            MOV [result], AX
                            JMP endProc
                    shr3:
                            SHR AX, 3
                            MOV [result], AX
                            JMP endProc
                    shr4:
                            SHR AX, 4
                            MOV [result], AX
                            JMP endProc

            multiply:

                    XOR AX, AX
                    XOR BX, BX
                    MOV AX, [liczba1]       
                    MOV BX, [liczba2]    

                    CMP BX, 1
                    JE shl1

                    CMP BX, 2
                    JE shl2

                    CMP BX, 3
                    JE shl3

                    CMP BX, 4
                    JE shl4

                    CMP BX, 5
                    JE shl5

                    CMP BX, 6
                    JE shl6

                    CMP BX, 7
                    JE shl7

                    CMP BX, 8
                    JE shl8

                    CMP BX, 9
                    JE shl9

                    CMP BX, 10
                    JE shl10

                    CMP BX, 11
                    JE shl11

                    CMP BX, 12
                    JE shl12

                    CMP BX, 13
                    JE shl13

                    CMP BX, 14
                    JE shl14

                    CMP BX, 15
                    JE shl15

                    CMP BX, 16
                    JE shl16

                    shl1:
                            MOV [result], AX       
                            JMP endProc
                    shl2:
                            SHL AX, 1
                            MOV [result], AX        
                            JMP endProc
                    shl3:
                            SHL AX, 1
                            MOV [result], AX
                            SHR AX, 1               
                            ADD [result], AX
                            JMP endProc
                    shl4:
                            SHL AX, 2
                            MOV [result], AX        
                            JMP endProc
                    shl5:
                            SHL AX, 2
                            MOV [result], AX
                            SHR AX, 2               
                            ADD [result], AX
                            JMP endProc
                    shl6:
                            SHL AX, 2
                            MOV [result], AX
                            SHR AX, 1               
                            ADD [result], AX
                            JMP endProc        
                    shl7:
                            SHL AX, 3
                            MOV [result], AX
                            SHR AX, 3              
                            SUB [result], AX
                            JMP endProc        
                    shl8:
                            SHL AX, 3
                            MOV [result], AX        
                            JMP endProc

                    shl9:
                            SHL AX, 3
                            MOV [result], AX
                            SHR AX, 3               
                            ADD [result], AX
                            JMP endProc
                   shl10:
                            SHL AX, 3
                            MOV [result], AX
                            SHR AX, 2               
                            ADD [result], AX
                            JMP endProc
                    shl11:
                            SHL AX, 3
                            MOV [result], AX
                            SHR AX, 1
                            ADD [result], AX    
                            SHR AX, 2
                            SUB [result], AX
                            JMP endProc
                    shl12:
                            SHL AX, 3
                            MOV [result], AX
                            SHR AX, 1               
                            ADD [result], AX
                            JMP endProc
                    shl13:
                            SHL AX, 3
                            MOV [result], AX
                            SHR AX, 1
                            ADD [result], AX
                            SHR AX, 2               
                            ADD [result], AX
                            JMP endProc
                    shl14:
                            SHL AX, 4
                            MOV [result], AX
                            SHR AX, 3               
                            SUB [result], AX
                            JMP endProc     
                    shl15:
                            SHL AX, 4
                            MOV [result], AX
                            SHR AX, 4
                            SUB [result], AX
                            JMP endProc
                    shl16:
                            SHL AX, 4
                            MOV [result], AX        
                            JMP endProc

endProc:

            XOR AX, AX
            XOR BX, BX

RET
;----------------------------------------------------------------