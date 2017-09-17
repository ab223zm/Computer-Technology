;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2016-09-05
; Author:
; Student name 1 Ruth Dirnfeld
; Student name 2 Alexandra Bjäremo
;
; Lab number: 1
; Title: How to use the PORTs. Digital input/output. Subroutine call.
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Describe the function of the program, so that you can understand it,
; even if you're viewing this in a year from now!
;
; Input ports: Describe the function of used ports, for example on-board switches
; connected to PORTA.
;
; Output ports: Describe the function of used ports, for example on-board LEDs
; connected to PORTB.
;
; Subroutines: If applicable.
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

ldi r16, 0xFF 
out DDRB, r16 

ldi r16, 0x00 
out DDRA, r16 

ldi r17, 1

loop:

in r18, PINA
cpi r18, 0xFF
breq output
inc r17
cpi r17, 7
brne jmpLoop
ldi r17, 1
jmpLoop:
rjmp loop

output:
cpi r17, 1
breq one
cpi r17, 2
breq two
cpi r17, 3
breq three
cpi r17, 4
breq four
cpi r17, 5
breq five
cpi r17, 6
breq six

one:
ldi r16, 0b0001_0000
out DDRB, r16
rjmp loop
two:
ldi r16, 0b0100_0100
out DDRB, r16
rjmp loop
three:
ldi r16, 0b0101_0100
out DDRB, r16
rjmp loop
four:
ldi r16, 0b1100_0110
out DDRB, r16
rjmp loop
five:
ldi r16, 0b1101_0110
out DDRB, r16
rjmp loop
six:
ldi r16, 0b1110_1110
out DDRB, r16
rjmp loop



