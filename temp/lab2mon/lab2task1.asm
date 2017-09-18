
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2016-09-05
; Author:
; Student name 1 Ruth Dirnfeld
; Student name 2 Alexandra Bj�remo
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

; Initialize SP, Stack Pointer
ldi r20, HIGH(RAMEND) ; R20 = high part of RAMEND address
out SPH,r20 ; SPH = high part of RAMEND address
ldi R20, low(RAMEND) ; R20 = low part of RAMEND address
out SPL,R20 ; SPL = low part of RAMEND address

ldi r20, 0xFF
out DDRB, r20				; All one's to DDRB, outputs

ldi r16, 0xFE				; starting with LED0
ldi r17, 0x00				; temp register to help with sloop

ldi r22, 0xFE               
out DDRA, r22               ; One zero to DDRA, input

ring:

in r22, PINA
cpi r22, 0x00
breq firstLoop
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

rjmp ring

; Generated by delay loop calculator
; at http://www.bretmulvey.com/avrdelay.html
;
; Delay 500 000 cycles
; 500ms at 1 MHz

delay:
	push r18
	push r19
	push r21

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
	
	pop r21
	pop r19
	pop r18	
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;TASK6


johnsonLeft:
in r22, PINA
cpi r22, 0x00
breq secondLoop
cpi r16, 0x00				; check if all LEDs are on
breq johnsonRight
out PORTB, r16				; write to PORTB
lsl r16					; pushing 0 to the left to turn on next light aswell
rcall delay
rjmp johnsonLeft

johnsonRight:
in r22, PINA
cpi r22, 0x00
breq secondLoop
out PORTB, r16				; write to PORTB
cpi r16, 0xFF				; check if all LEDs are off
breq johnsonLeft				
mov r17, r16				; move r16's bits to r17
com r17					; invert r17's bits	
lsr r17					; pushing 0 to the right 
com r17					; invert r17's bits again
mov r16, r17				; move r17's bits to r16
rcall delay
rjmp johnsonRight

firstLoop:
ldi r16, 0xFF
out PORTB, r16
rjmp johnsonLeft

secondLoop:
ldi r16,0xFF
out PORTB, r16
rjmp ring