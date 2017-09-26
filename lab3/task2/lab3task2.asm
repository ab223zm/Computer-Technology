;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-25
; Author:
; Student name 1 Ruth Dirnfeld
; Student name 2 Alexandra Bj�remo
;
; Lab number: 3
; Title: Interrupts.
;
; Hardware: STK600, CPU ATmega2560
;
; Function: A program that switches between Ring counter and Johnson counter by using Interrupts
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
; Changes in program: 2017-09-26.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

.org 0x00
rjmp start

.org INT0addr
rjmp interrupt_0
.org INT1addr
rjmp interrupt_1

.org 0x72

start:
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
out DDRD, r23

ldi r22, 0x00				; keep track of counters, if 0 then ring, else johnson

ldi r24, 0x03				; INT0 and INT1 enabled
out EIMSK, r24

ldi r24, 0x08				; INT1 falling edge, INT0 rising edge
sts EICRA, r24

sei							; global interrupt enable



main:
	cpi r22, 0x00
	breq ring
	rjmp johnsonLeft
rjmp main



ring:
	cpi r16, 0xFF			; checking if all LEDs are off
	breq equal				
	out PORTB, r16			; write in PORTB, turning on LEDs
	com r16					; inverting the bits of r16				
	lsl r16					; pushing a 0 to the left
	com r16					; inverting the bits of r16 again
	rcall delay
	rjmp ring

	
johnsonLeft:
cpi r22, 0x00
breq ring
cpi r16, 0x00				; check if all LEDs are on
breq johnsonRight
out PORTB, r16				; write to PORTB
lsl r16						; pushing 0 to the left to turn on next light aswell
rcall delay
rjmp johnsonLeft

johnsonRight:
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
    rjmp PC+1

	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;TASK6


interrupt_0:
interrupt_1:
	ldi r16, 0xFF			
	out PORTB, r16			; turn off all LEDs, to stop the counter
	com r22					; invert r22 to change counter
reti

