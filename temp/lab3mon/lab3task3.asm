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
jmp interrupt_0

.org INT1addr
jmp interrupt_1

.org 0x72

start:
ldi r16, HIGH(RAMEND) 
out SPH, r16 
ldi r16, LOW(RAMEND) 
out SPL, r16 

ldi r20, 0x00
out DDRD, r20			; all zero's to DDRD, input

ldi r20, 0xFF
out DDRB, r20			; all one's to DDRB, outputs

ldi r20, 0x03			; INT0 and INT1 enabled
out EIMSK, r20

ldi r20, 0x15			; INT1 falling edge, INT0 rising edge
sts EICRA, r20	

sei				; global interrupt enable

ldi r16, 0x00		
ldi r18, 0x00		
ldi r21, 0x00		
ldi r22, 0x00		

main:
	cpi r16, 0x00
	breq right		; if right-button is pressed
	cpi r22, 0x00
	breq left		; if left-button is pressed

	ldi r20, 0b11000011     ;normal state of left and right side
	out DDRB, r20
	rjmp main

left:
	ldi r20, 0x10           ;loading with 0001_0000
	loop1:
		cpi r20, 0x00
		breq left

		mov r17, r16
		ldi r18, 0x03   ;loading with 0000_0011
		add r17, r18 

		out DDRB, r17
		;rcall delay1

		lsl r20
		rjmp loop1

right:
	ldi r20, 0x08            ;loading with 0000_1000
	loop2:
		cpi r20, 0x00
		breq right

		mov r17, r20
		ldi r18, 0xC0    ; loading with 1100_0000
		add r17, r18 

		out DDRB, r17
		;rcall delay1

		lsr r20
		rjmp loop2

delay1:
	
	ldi r16, 2		; innner count
	ldi r17, 2		; middle count
	ldi r18, 2		; outer count

	delay2:

		dec r18
		brne delay2

		dec r17
		brne delay2

		dec r20
		brne delay2
		nop
	ret

interrupt_0:			
	com r16			; inverting
	reti
interrupt_1:			
	com r22
	reti


