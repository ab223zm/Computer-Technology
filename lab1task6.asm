.include "m2560def.inc"

; Initialize SP, Stack Pointer
ldi r20, HIGH(RAMEND) ; R20 = high part of RAMEND address
out SPH,r20 ; SPH = high part of RAMEND address
ldi R20, low(RAMEND) ; R20 = low part of RAMEND address
out SPL,R20 ; SPL = low part of RAMEND address

ldi r20, 0xFF
out DDRB, r20

ldi r16, 0xFE
ldi r17, 0x00

floop:
cpi r16, 0x00
breq sloop
out PORTB, r16
lsl r16
rcall delay
rjmp floop

sloop:
out PORTB, r16
cpi r16, 0xFF
breq floop
mov r17, r16
com r17
lsr r17
com r17
mov r16, r17
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

ret

