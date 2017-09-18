;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-09
; Author:
; Student name 1 Ruth Dirnfeld
; Student name 2 Alexandra Bjäremo
;
; Lab number: 2
; Title: Change counter
;
; Hardware: STK600, CPU ATmega2560
;
; Function: A program that is able to count the number of changes on a switch.
;
; Input ports: PORTA.
; 
; Output ports: On-board LEDs connected to PORTB.
;
; Subroutines: Delay of approximately 0,5 sec in between each count.
; Included files: m2560def.inc
;
; Other information: Using a loop to make the counter work infinitely.
;
; Changes in program: File created - 2017-09-18.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.def counter = r17 

ldi counter, 0x00
rjmp main

switch:
inc counter		; pushed

loop:
in r16, PINA
cpi r16, -1 	; release all switches
brne loop
inc counter		; released

out DDRB, counter

main:
in r16, PINA
cpi r16, 0xFE		; sw0 is pushed
breq switch

rjmp main

/*
.def counter = R17

ldi counter, 0

main:
ldi r16, 0

switch:
in r18, PIND
cpi r18, 0xFF
breq stoplistening

cpi r18, 0xFE
brne continue

cpi r16, 0
brne continue
rcall update
ldi r16, 0xFF

continue :
rjmp switch

stoplistening:
cpi r16, 0xFF
brne main
rcall update
rjmp main

update:
inc counter
mov r19, counter
com r19
out PORTB, r19
ret
*/
