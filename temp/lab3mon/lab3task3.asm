;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-25
; Author:
; Student name 1 Ruth Dirnfeld
; Student name 2 Alexandra Bjäremo
;
; Lab number: 3
; Title: Interrupts.
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Turning ON and OFF a LED with a push button.
;
; Input ports: On-board switches connected to DDRD.
;
; Output ports: On-board LEDs connected to DDRB.
;
; Subroutines: interrupt_0, interrupt_1
; Included files: m2560def.inc
;
; Other information: None.
;
; Changes in program: None.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

.org 0x00
rjmp start

.org INT0addr
rjmp interrupt_0
/*.org INT1addr
rjmp interrupt_1
*/
.org 0x72

start:
ldi r16, HIGH(RAMEND) ; MSB part av address to RAMEND
out SPH, r16 ; store in SPH
ldi r16, LOW(RAMEND) ; LSB part av address to RAMEND
out SPL, r16 ; store in SPL

ldi r22, 0x00
out DDRD, r22			; all zero's to DDRD, input

ldi r20, 0xFF
out DDRB, r20			; all one's to DDRB, outputs

ldi r20, 0x03			; INT0 and INT1 enabled
out EIMSK, r20

ldi r20, 0x08			; INT1 falling edge, INT0 rising edge
sts EICRA, r20

sei						; global interrupt enable

main:

ldi r20, 0x3C
out PORTB, r20

ldi r17, 0x04

rjmp main

interrupt_0:
	cpi r20, 0x3F				; checking if all LEDs are off
	breq equal	
	add r20, r17
	ror r17			
	out PORTB, r20				; write in PORTB, turning on LEDs
	;rcall delay
reti

	equal: 
	ldi r20, 0x37			

rjmp main

delay:
	
    ldi  r18, 3
    ldi  r19, 138
    ldi  r21, 86
L1: dec  r21
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    rjmp PC+1
ret


