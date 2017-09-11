.include "m2560def.inc"


ldi r16, 0xFF
out DDRB, r16

ldi r16, 0b00000000
out DDRA, r16

loop:
in r16, PINA
out PORTB, r16

rJmp loop
