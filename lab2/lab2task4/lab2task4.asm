;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-18
; Author:
; Student name 1 Ruth Dirnfeld
; Student name 2 Alexandra Bjäremo
;
; Lab number: 2
; Title: Subroutines.
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Adaptation of Ring counter, in which the delay is changeable depending 
; on the decided input
;
; Input ports: None.
;
; Output ports: On-board LEDs connected to PORTB.
;
; Subroutines: Delay that is changeable.
; Included files: m2560def.inc
;
; Other information: Clock set at 1MHz.
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

; Depending on the integer value set in the registers the 
; delay will either increase or decrease
wait_milliseconds:
	push r24
	push r25
d_loop:
	dec r24
	brne d_loop
	dec r25
	brned_loop
delay:
	ldi r18, 3
	ldi r19, 138
	ldi r22,86
	L1:
	dec r22
	brne L1		
	dec r19				
	brne L1
	dec r18
	brne L1
	rjmp PC+1		
ret

