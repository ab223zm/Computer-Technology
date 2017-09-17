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

ldi r20, HIGH(RAMEND) ; R20 = high part of RAMEND address
out SPH,r20 ; SPH = high part of RAMEND address
ldi R20, low(RAMEND) ; R20 = low part of RAMEND address
out SPL,R20 ; SPL = low part of RAMEND address

ldi r24, low(1500)
ldi r25, HIGH(1500)

ldi r20, 0xFF
out DDRB, r20				; All one's to DDRB, outputs

ldi r16, 0xFE				; starting with LED0

floop:
cpi r16, 0xFF				; checking if all LEDs are off
breq equal				
out PORTB, r16				; write in PORTB, turning on LEDs
rol r16
rcall wait_milliseconds
rjmp floop

equal: 
ldi r16, 0xFE			

rjmp floop

; Generated by delay loop calculator
; at http://www.bretmulvey.com/avrdelay.html
;
; Delay 500 000 cycles
; 500ms at 1 MHz


wait_milliseconds:
    adiw r25:r24, 0x01
    ldi  r18, 11
    ldi  r19, 99
L1: dec  r19
    brne L1
    dec  r18
    brne L1
    rjmp PC+1
ret
