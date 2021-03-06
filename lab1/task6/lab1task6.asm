;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-11
; Author:
; Student name 1 Ruth Dirnfeld
; Student name 2 Alexandra Bjäremo
;
; Lab number: 1
; Title: How to use the PORTs. Digital input/output. Subroutine call.
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Creating a Johnson Counter, that will light up each LED at
; a time, while keeping the previous ones lit.
;
; Input ports: None.
; 
; Output ports: On-board LEDs connected to PORTB.
;
; Subroutines: Delay of approximately 0,5 sec in between each count.
; Included files: m2560def.inc
;
; Other information: Using loops to make the counter work infintely.
;
; Changes in program: Changed the last line from rjmp floop to ret
;(2017-09-11)
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

ldi r16, 0xFE				; turn on LED0
ldi r17, 0x00				; temp register to help with sloop

floop:
cpi r16, 0x00				; check if all LEDs are on
breq sloop
out PORTB, r16				; write to PORTB
lsl r16					; pushing 0 to the left to turn on next light aswell
rcall delay
rjmp floop

sloop:
out PORTB, r16				; write to PORTB
cpi r16, 0xFF				; check if all LEDs are off
breq floop				
mov r17, r16				; move r16's bits to r17
com r17					; invert r17's bits	
lsr r17					; pushing 0 to the right 
com r17					; invert r17's bits again
mov r16, r17				; move r17's bits to r16
rcall delay
rjmp sloop

; Generated by delay loop calculator
; at http://www.bretmulvey.com/avrdelay.html
;
; Delay 500 000 cycles
; 500ms at 1 MHz

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

ret					; return to subroutine


