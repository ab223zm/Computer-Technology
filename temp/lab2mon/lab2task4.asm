;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-09
; Author:
; Student name 1 Ruth Dirnfeld
; Student name 2 Alexandra Bjäremo
;
; Lab number: 2
; Title: How to use the PORTs. Digital input/output. Subroutine call.
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Creating a Ring Counter, that will light up each LED at
; a time, while turning the previous one off.
;
; Input ports: None.
; 
; Output ports: On-board LEDs connected to PORTB.
;
; Subroutines: Delay of approximately 0,5 sec in between each count.
; Included files: m2560def.inc
;
; Other information: Using a loop to make the counter work infinitely.
;
; Changes in program: None.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


.include "m2560def.inc"

; Initialize SP, Stack Pointer
ldi r20, HIGH(RAMEND) ; R20 = high part of RAMEND address
out SPH,r20 ; SPH = high part of RAMEND address
ldi R20, low(RAMEND) ; R20 = low part of RAMEND address
out SPL,R20 ; SPL = low part of RAMEND address

ldi r20, 0xFF
out DDRB, r20				; All one's to DDRB, outputs

ldi r16, 0xFE				; starting with LED0

floop:
cpi r16, 0xFF				; checking if all LEDs are off
breq equal				
out PORTB, r16				; write in PORTB, turning on LEDs
com r16						; inverting the bits of r16				
lsl r16						; pushing a 0 to the left
com r16						; inverting the bits of r16 again

ldi r24, low(600)			; Loading integer to register pair r25:r24
ldi r25, high(600)
rcall wait_milliseconds		; Call the wait_milliseconds subroutine
rjmp floop

equal: 
ldi r16, 0xFE			

rjmp floop

wait_milliseconds:

	L:
	ldi r20, low(600)
	ldi r21, high(600)

	L1:
	dec r20
	nop
	brne L1
					
	dec r21
	nop
	brne L1

	sbiw r25:r24, 1			
	brne L					

ret