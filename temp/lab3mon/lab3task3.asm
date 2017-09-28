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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;new attempt
.include "m2560def.inc"

.org 0x00
rjmp start

.org INT0addr
jmp interrupt_0
.org INT1addr
jmp interrupt_1

.org 0x72

start:
ldi r16, HIGH(RAMEND)	; MSB part av address to RAMEND
out SPH, r16			; store in SPH
ldi r16, LOW(RAMEND)	; LSB part av address to RAMEND
out SPL, r16			; store in SPL

ldi r20, 0x00
out DDRD, r20			; all zero's to DDRD, input

ldi r20, 0xFF
out DDRB, r20			; all one's to DDRB, outputs

/*
ldi r17, 0xA0			; temp for eor  1010_0000
ldi r18, 0x0A			; temp for eor  0000_1010
*/

ldi r20, 0x03			; INT0 and INT1 enabled
out EIMSK, r20

ldi r20, 0x08			; INT1 falling edge, INT0 rising edge
sts EICRA, r20

sei						; global interrupt enable

main:
/*ldi r22, 0x3C			; 0b0011_1100			
out PORTB, r22			; normal light-up of LEDs
*/
ldi r22, 0xC3
out DDRB, r22
rjmp main

;turning right
interrupt_0:
ldi r20, 0x08
loop1:
mov r22, r20
ldi r23, 0xC0
add r22, r23
out DDRB, r22
rcall delay1
lsr r20
brne loop1

rjmp main



/*ldi r22, 0x37			; starting ring for turning right 0011_0111
out PORTB, r22
ror r22					; shifting which LEDs are on
eor r22, r17			; XOR r22 with r17 to get back bits 4-7
out PORTB, r22			; outing to the LEDs
reti*/

;turning left
interrupt_1:
ldi r20, 0x10
loop2:
mov r22, r20
ldi r23, 0x03
add r22, r23
out DDRB, r22
rcall delay1
lsl r20
brne loop2

rjmp main

delay1: ldi r20, 0x08
delay2: ldi r22, 0x64
delay3: ldi r23, 0xFA
L1:
dec r23
brne L1 
dec r22
nop
brne delay3
dec r20
brne delay2
ret
/*ldi r22, 0xEC			; starting ring for turning left  1110_1100
out PORTB, r22
rol r22					; shifting which LEDs are on
eor r22, r18			; XOR r22 with r18 to get back bits 0-3
out PORTB, r22			; outing to the LEDs
*/
//ldi r19, 200
/*delay_int:
	dec r19
	cpi r19,0
	brne delay_int*/
	
//reti
