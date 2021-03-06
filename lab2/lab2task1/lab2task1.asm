;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-12
; Author:
; Student name 1: Ruth Dirnfeld
; Student name 2: Alexandra Bj�remo
;
; Lab number: 2
; Title: Subroutines
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Switching between the Ring and the Johnson counters when pressing SW0
;
; Input ports: On-board switches connected to PORTA.
;
; Output ports: On-board LEDs connected to PORTB.
;
; Subroutines: Delay of approximately 0,5 sec in between each count.
; Included files: m2560def.inc
;
; Other information: Clock set at 1MHz
;
; Changes in program: File updates: 2017-09-16, 2017-09-18, 2017-09-19
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
ldi r17, 0x00				; temp register to help with sloop

ldi r23, 0x00
out DDRA, r23

ldi r22, 0x00				; keep track of counters, if 0 then ring, else johnson


main:
	ring:
		ldi r23, 0x00
		cpi r16, 0xFF				; checking if all LEDs are off
		breq equal				
		out PORTB, r16				; write in PORTB, turning on LEDs
		com r16						; inverting the bits of r16				
		lsl r16						; pushing a 0 to the left
		com r16						; inverting the bits of r16 again
	rcall delay
	rjmp ring

	equal: 
	ldi r16, 0xFE			

rjmp main

; Generated by delay loop calculator
; at http://www.bretmulvey.com/avrdelay.html
;
; Delay 500 000 cycles
; 500ms at 1 MHz

delay:
	ldi  r18, 3
    ldi  r19, 138
    ldi  r21, 86	
L1:	dec  r21
    brne L1
	dec  r19
    brne L1
    dec  r18
    brne L1
	in r23, PINA					; read PINA
	cpi r23, 0xFE					; check if button is pressed
	breq pressed	
    rjmp PC+1

ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;TASK6


johnsonLeft:
ldi r23, 0x00
cpi r16, 0x00				; check if all LEDs are on
breq johnsonRight
out PORTB, r16				; write to PORTB
lsl r16						; pushing 0 to the left to turn on next light aswell
rcall delay
rjmp johnsonLeft

johnsonRight:
ldi r23, 0x00
out PORTB, r16				; write to PORTB
cpi r16, 0xFF				; check if all LEDs are off
breq johnsonLeft				
mov r17, r16				; move r16's bits to r17
com r17						; invert r17's bits	
lsr r17						; pushing 0 to the right 
com r17						; invert r17's bits again
mov r16, r17				; move r17's bits to r16
rcall delay
rjmp johnsonRight

pressed:
	com r22					; invert r22 to change counter
	cpi r22,0x00 			; check if counter is set to Ring counter
	breq jumpToRing
	rjmp jumpToJohnsonLeft

jumpToRing:
	ldi r16, 0xFF			
	out PORTB, r16			; turn off all LEDs
	rjmp ring
jumpToJohnsonLeft:
	ldi r16, 0xFF
	out PORTB, r16			; turn off all LEDs
	rjmp johnsonLeft

