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
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;next attempt

.include "m2560def.inc"



.org 0x00
rjmp start

.org INT0addr
jmp interrupt0
.org INT1addr
jmp interrupt1
.org INT2addr
jmp interrupt2

.org 0x72
start:
ldi r20, high(ramend); initialize SP, stack pointer
out sph, r20
ldi r20, low(ramend)
out spl, r20		

ldi r16, 0x00		
out ddrd, r16		; port a - output

ldi r16, 0xff		; set pull-up resistors on d input pin
out ddrb, r16		; port b - output

ldi r16, 0b00000111		; int0 and int1 and (purhaps also int2) enabled
out EIMSK, r16

ldi r16, 0b00010101
sts EICRA, r16		; int1 falling edge, int0 rising edge

sei					; global interupt enable

ldi r18, 0xff		; switch
ldi	r20, 0xff		; right
ldi r21, 0xff		; break
ldi r22, 0xff		; left

normal:
	cpi r20, 0x00
	breq right		; if right-btn is pushed down
	cpi r22, 0x00
	breq left		; if left-btn is pushed down

	ldi r16, 0b11000011
	out ddrb, r16
	rjmp normal

left:
	ldi r16, 0x10
	loopl:
		cpi r16, 0x00
		breq left

		mov r17, r16
		ldi r18, 0x03
		add r17, r18 

		out ddrb, r17
		rcall deley


		lsl r16
		rjmp loopl

right:
	ldi r16, 0x08
	loopr:
		cpi r16, 0x00
		breq right

		mov r17, r16
		ldi r18, 0xc0
		add r17, r18 

		out ddrb, r17
		rcall deley


		lsr r16
		rjmp loopr


deley:				; 4MHz -> 4000000 cycles = 1s,  Cycles = 3a + 4ab + 10abc   ->  a(3 + b(4 + 10c)),  ((250 * 10 + 4) * 100 + 3) * 8 = 2 003 224 ~ 2 000 000
	ldi r16, 8		; -> a
deley_1:
	ldi r17, 100	; -> b
deley_2:
	ldi r18, 250	; -> c

deley_3:

	nop
	nop
	nop
	nop
	nop
	nop
	nop

	dec r18
	brne deley_3	; 10c - 1		-> d

	dec r17
	nop
	brne deley_2	; 5b - 1 + bd	-> e = 5b - 1 + 10cb - b

	dec r16
	brne deley_1	; 5a - 1 + ae	-> f = 3a + 5ab + 10abc - ab
	ret				; f - 1







interrupt0:			; left	< 0000.0001 >
	com r20		; push -> 0x00
	reti
interrupt2:			; right	< 0000.0010 >
	com r22
	reti
interrupt1:
	com r21
	reti
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;new attempt

.include "m2560def.inc"

.org 0x00
rjmp start

.org INT1addr
jmp interrupt0

.org INT3addr
jmp interrupt2

.org 0x72
start:
;initialize SP, stack pointer
ldi r20, high(ramend)
out sph, r20
ldi r20, low(ramend)
out spl, r20		

ldi r16, 0x00		
out DDRA, r16		; port a input pin

ldi r16, 0xff		; set pull-up resistors on A input pin
out DDRB, r16		; port b - output

ldi r16, 0b00001110		; int0 and int1 and (perhaps also int2) enabled
out EIMSK, r16

ldi r16, 0b01010100
sts EICRA, r16		; int1 falling edge, int0 rising edge
sei					; global interupt enable

ldi r23, 0x00	; left register
ldi r19, 0x00	; right register
ldi r20, 0x00
ldi r22, 0x00

init:
	pop r17	; this value will be changed
	sei

normal:
	ldi r17, 0b11000011
	cpi r20, 0xff
	breq right
	ar:
		cpi r22, 0xff
		breq left
	al:
		out DDRB, r17
		rcall delay
		rjmp normal

left:	
	andi r17, 0b00001111 ; 'flush' led 5-8
	cpi r23, 0x00
	brne leftshift
	
	ldi r23, 0b00010000
	rjmp leftadd

	leftshift:
		lsl r23
	leftadd:
		add r17, r23
	rjmp al

right:	
	andi r17, 0b11110000 ; 'flush' led 0-4
	cpi r19, 0x00
	brne rightshift
	ldi r19, 0b00001000
	rjmp rightadd
	
	rightshift:
		lsr r19
	rightadd:
		add r17, r19
	rjmp ar
	
delay:				; 16MHz -> 16000000 cycles = 1s,  Cycles = 3a + 4ab + 10abc   ->  a(3 + b(4 + 10c)),  ((250 * 10 + 4) * 100 + 3) * 8 = 2 003 224 ~ 2 000 000
	ldi r16, 8		; -> a
delay_1:
	ldi r17, 100	; -> b
delay_2:
	ldi r18, 250	; -> c
delay_3:
	dec r18
	brne delay_3	; 10c - 1		-> d ( not 10 anymore... 3)
	dec r17
	nop
	brne delay_2	; 5b - 1 + bd	-> e = 5b - 1 + 10cb - b
	dec r16
	brne delay_1	; 5a - 1 + ae	-> f = 3a + 5ab + 10abc - ab
	ret				; f - 1

interrupt0:		; right
	com r20
	rjmp init

interrupt2:		; left
	com r22
	rjmp init
