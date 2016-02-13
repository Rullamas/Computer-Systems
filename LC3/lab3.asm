; CMPE12 - Spring 2013
; 2digit.asm
; Brandon Rullamas - brullama
;
; This program subtracts, multiplies,
; and divides a user's input.



; The code will begin in memory at the address
; specified by .orig <number>.

	.ORIG   x3000


START:
; clear all registers that we may use
	AND	R0, R0, 0
	AND	R1, R0, 0
	AND	R2, R0, 0
	AND	R3, R0, 0
	AND	R4, R0, 0
	AND	R5, R0, 0
	AND	R6, R0, 0

; print out a newline
	LEA 	R0, NEWLINE
	PUTS

; print out a greeting prompting for number
	LEA	R0, GREETING
	PUTS

; get a user-entered number (result in R0)
; echo it back right away (otherwise it isn't visible)
	GETC
	PUTC

; use R5 to subtract -48 from R0
	LD 	R5, NEG48
	ADD 	R0, R0, R5
	;JSR 	TWOCOMP
	;STI	R0, MEM2COMP

; store entered number (otherwise it may be overwritten)
	ST	R0, USERINPUT

; print out a newline
	LEA	R0, NEWLINE
	PUTS

; print out second greeting prompting for number
	LEA	R0, GREETING2
	PUTS

; get a user-entered number (result in R0)
; echo it back right away
	GETC
	PUTC

; use R5 to subtract -48 from R1
	ADD 	R0, R0, R5
	;JSR 	TWOCOMP
	;STI	R0, MEM2COMP

; store entered number
	ST	R0, USERINPUT2

; use R6 to add 48 later on
	LD 	R6, POS48

; print out a newline
	LEA	R0, NEWLINE
	PUTS

; call subroutines
	JSR 	SUB

; print out subtraction
	LEA 	R0, SUBTRACTION
	PUTS
	LD  	R0, SUBLOC
	PUTC
	LEA	R0, NEWLINE
	PUTS

; call multiplication subroutine
	JSR	MUL

; print out multiplication
	LEA 	R0, MULTIPLICATION
	PUTS
	LD 	R0, MULLOC
	AND	R1, R1, #0
	ADD	R1, R1, R0
	LD	R5, NEG48
	ADD	R1, R1, R5
	BRz	REMAIN
	PUTC
REMAIN	LD	R0, MULREM
	PUTC
	LEA	R0, NEWLINE
	PUTS

; call division subroutine
	JSR DIV

; print out division
	LEA 	R0, DIVISION
	PUTS
	LD 	R0, DIVLOC
	PUTC
	LEA	R0, NEWLINE
	PUTS
	LEA 	R0, REMAINDER
	PUTS
	LD 	R0, REMLOC
	PUTC
	LEA	R0, NEWLINE
	PUTS

; stop the processor
	HALT

; data declarations follow below

; strings
GREETING:	.STRINGZ	"Please enter a 1-digit number: "
GREETING2:	.STRINGZ	"Please enter a second 1-digit number: "
NEWLINE:	.STRINGZ 	"\n"
SUBTRACTION:	.STRINGZ	"Subtracted: "
MULTIPLICATION:	.STRINGZ	"Multiplicated: "
DIVISION:	.STRINGZ	"Divided: "
REMAINDER:	.STRINGZ	"Remainder: "

; variables
NEG48:		.FILL	#-48
POS48:		.FILL	#48
USERINPUT:	.FILL	x0
USERINPUT2:	.FILL	x0
MEMR7:		.FILL	X0
SUBLOC:		.FILL	x3100
MULLOC:		.FILL   x3101
DIVLOC:		.FILL	x3102
REMLOC:		.FILL	x3103
MULREM:		.FILL	x3104

; beginning of subtraction subroutine
SUB:
	ST	R7, MEMR7
	LD	R1, USERINPUT2
	LD	R0, USERINPUT
	NOT 	R2, R1 		; invert r1
	ADD 	R1, R2, #1 	; add 1 to negative value
	ADD 	R0, R0, R1 	; add negative value to positive
	ADD	R0, R0, R6	; add 48 to make ASCII
	ST 	R0, SUBLOC	; store result in SUBLOC
	LD	R7, MEMR7
	RET 			; return

; beginning of multiplication subroutine
MUL:
	ST	R7, MEMR7
	LD	R1, USERINPUT2
	LD	R4, USERINPUT
	ADD 	R2, R1, #0 	; create counter
	AND	R0, R0, #0
RESTART	ADD 	R0, R0, R4 	; add to sum
	ADD 	R2, R2, #-1 	; decrement counter
	; continue until 2nd number is 0
	BRp RESTART
	AND	R5, R5, #0
	ADD	R5, R5, #-10
	AND	R3, R3, #0
	AND	R4, R4, #0
LOOP	ADD	R3, R3, #1
	ADD	R0, R0, R5
	BRn	NEG
	BRz	ZERO
	BRp	LOOP
NEG	ADD	R3, R3, #-1
	AND	R5, R5, #0
	ADD	R5, R5, #10
	ADD	R4, R0, R5
ZERO	ADD	R3, R3, R6
	ADD	R4, R4, R6
	ST 	R3, MULLOC 	; store result in MULLOC
	ST	R4, MULREM
	LD	R7, MEMR7
	RET 			; return

; beginning of division subroutine
DIV:
	ST	R7, MEMR7
	LD	R1, USERINPUT2
	LD	R0, USERINPUT
	AND 	R3, R3, #0 	; create quotient
	AND	R4, R4, #0	; create remainder
	NOT 	R2, R1 		; invert r1
	ADD 	R2, R2, #1 	; add 1 to negative value
LOOP1	ADD 	R3, R3, #1 	; increment counter
	ADD	R0, R0, R2	; add negative value to positive
	BRn 	NEG1		; check for negative
	BRz 	ZERO1		; check for zero
	BRp 	LOOP1		; else loop
NEG1	ADD	R3, R3, #-1	; if neg, go back one in quotient
	ADD	R4, R0, R1	; add original input to 'quotient'
ZERO1	ADD	R4, R4, R6	; add 48 to quotient
	ADD	R3, R3, R6	; add 48 to remainder
	ST 	R3, DIVLOC 	; store result in DIVLOC
	ST 	R4, REMLOC 	; store remainer in REMLOC
	LD	R7, MEMR7
	RET

; end of code
	.END
