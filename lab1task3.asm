
.include "m2560def.inc"

ldi r16, 0b00000001
out DDRB, r16

ldi r16, 0b11011111
out DDRA, r16  

loop:

ldi r16, 0b11111111
out PORTB, r16

in r16, PINA

cpi r16, 0
brne loop

ldi r16, 0b11111110
out PORTB,r16

rJmp loop
