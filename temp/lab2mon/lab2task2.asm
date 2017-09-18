/*
 * lab2task2.asm
 *
 *  Created: 9/16/2017 2:36:48 PM
 *   Author: Ruthi
 */ 


.include "m2560def.inc"

ldi r16 ,0xFF 
out DDRB ,r16 

ldi r16 ,0x00 
out DDRA ,r16 

ldi r17 ,1

loop:
/*
in r20, PINA
cpi r20, 0xFF
brne loop

start:
inc r16
cpi r16, 7
breq rand
	
in r20, PINA
cpi r20, 0xFF
brne output
rjmp start

rand:
ldi r16, 1		; random output value
rjmp start

*/

in r18, PINA
cpi r18 ,0xFF
breq output
inc r17
cpi r17 ,7
brne continue
ldi r17 ,1
continue:
rjmp loop

output:
cpi r17 ,1
breq one
cpi r17 ,2
breq two
cpi r17 ,3
breq three
cpi r17 ,4
breq four
cpi r17 ,5
breq five
cpi r17 ,6
breq six

one:
ldi R16 , 0b1110_1111
out DDRB ,R16
rjmp loop
two:
ldi r16 , 0b1011_1011
out DDRB ,r16
rjmp loop
three:
ldi r16 , 0b1010_1011
out DDRB ,r16
rjmp loop
four:
ldi r16 , 0b0011_1001
out DDRB ,r16
rjmp loop
five:
ldi r16 , 0b0010_1001
out DDRB ,r16
rjmp loop
six:
ldi r16 , 0b0001_0001
out DDRB ,r16
rjmp loop
