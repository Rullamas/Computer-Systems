; CMPE12 - Spring 2013
; May 19, 2013
; lab4.asm
; Brandon Rullamas
; Susie Kim
; This program takes two two-digit inputs from the
; user and converts the inputs to floating point numbers.
; It then multiplies the two floating point numbers and
; outputs the result in floating point number format.

	.ORIG   x3000

START:
; clear all registers
	JSR CLEAR

; print out a newline
	LEA	R0, NEWLINE
	PUTS

; print out first greeting	
	LEA	R0, GREETING1
	PUTS

; get first input from user for first num
	GETC
	PUTC

; store entered input
	ST	R0, ONENUM1

; get second input from user for first num
	GETC
	PUTC

; store entered input
	ST	R0, ONENUM2

; print out a newline
	LEA	R0, NEWLINE
	PUTS

; print out second greeting
	LEA	R0, GREETING2
	PUTS

; get third input from user for second num
	GETC
	PUTC

; store entered input
	ST	R0, TWONUM1

; get fourth input from user for second num
	GETC
	PUTC

; store entered input
	ST	R0, TWONUM2

; print out a newline
	LEA	R0, NEWLINE
	PUTS

; convert first number to a decimal number
	LD	R1, ONENUM1
	LD	R2, ONENUM2
	JSR	CONV
	STI	R4, NUMBER1

;convert second number to a decimal number
	LD	R1, TWONUM1
	LD	R2, TWONUM2
	JSR	CONV
	STI	R4, NUMBER2

; convert first number to a floating point number
	LDI	R1, NUMBER1

; use a mask on the first number
	LD 	R2, MASK

; create the exponent using a count and mask
	LD	R4, COUNT
	JSR 	FLOAT				
	STI 	R4, EXPO1		
	NOT	R2, R2				
	AND 	R5, R1, R2			
	STI	R5, FRAC1

; convert second number to a floating point number
	LDI	R1, NUMBER2
	LD 	R2, MASK

; create the exponent using a count and mask
	LD	R4, COUNT
	JSR 	FLOAT
	STI 	R4, EXPO2
	NOT	R2, R2
	AND 	R5, R1, R2
	STI	R5, FRAC2

; combine the exponent and fraction/mantissa to
; result in the first floating point number
	JSR 	CLEAR
	LDI	R0, EXPO1
	LDI	R1, FRAC1

; make a counter that will tick ten times
	ADD	R2, R2, #10
	JSR	COMB
	ADD	R3, R0, R1
	STI	R3, RESULT1

; combine the exponent and fraction/mantissa to
; result in the first floating point number
	LDI	R0, EXPO2
	LDI	R1, FRAC2

; make a counter that will tick ten times
	ADD	R2, R2, #10
	JSR	COMB
	ADD	R3, R0, R1
	STI	R3, RESULT2

; print out a newline
	LEA	R0, NEWLINE
	PUTS
	
	JSR 	CLEAR

; make several different counters
	ADD	R2, R2, #1
	ADD	R3, R3, #6
; two R4 add statements due to size of bits			
	ADD	R4, R4, #15
	ADD	R4, R4, #1			
	LDI	R1, RESULT1

; print the first floating point number
	LEA	R0, FLOATPOINT1
	PUTS
	JSR	PRIFLO

; print out a newline
	LEA	R0, NEWLINE
	PUTS

	JSR 	CLEAR
; make several different counters
	ADD	R2, R2, #1
	ADD	R3, R3, #6
; two R4 add statements due to size of bits
	ADD	R4, R4, #15
	ADD	R4, R4, #1
	LDI	R1, RESULT2

; print the second floating point number
	LEA	R0, FLOATPOINT2
	PUTS
	JSR	PRIFLO

; print out a newline 
	LEA	R0, NEWLINE
	PUTS

; add the exponents of the floating
; point numbers
	JSR 	CLEAR
	LDI	R0, EXPO1
	LDI	R1, EXPO2
	ADD	R0, R0, R1

; remove the double bias
	ADD	R0, R0, #-15
	STI	R0, EXPOFIN

	JSR	CLEAR
; multiply the fractions/mantissas of
; the floating point numbers
	LD	R2, MASK
	LDI	R0, FRAC1

; add leading 1 to result
	ADD	R0, R0, R2

; shift numbers to account for 4 zeros (1.1)
	JSR	SHIFT 
	STI	R1, FRAC1		
	AND	R1, R1, #0
	LDI	R0, FRAC1
; second shift (1.2)
	JSR	SHIFT
	STI	R1, FRAC1
; reset first register
	AND	R1, R1, #0
	LDI	R0, FRAC1
; third shift (1.3)
	JSR	SHIFT
	STI	R1, FRAC1
; reset first register
	AND	R1, R1, #0
	LDI	R0, FRAC1
; fourth shift (1.4)
	JSR	SHIFT
	STI	R1, FRAC1
; reset first register
	AND	R1, R1, #0
	LDI	R0, FRAC2

; add leading 1 to result and repeat
	ADD	R0, R0, R2

; shift numbers to account for 4 zeros (2.1)
	JSR	SHIFT
	STI	R1, FRAC2
; reset first register	
	AND	R1, R1, #0
	LDI	R0, FRAC2
; second shift (2.2)
	JSR	SHIFT
	STI	R1, FRAC2
; reset first register
	AND	R1, R1, #0
	LDI	R0, FRAC2
; third shift (2.3)
	JSR	SHIFT
	STI	R1, FRAC2
; reset first register
	AND	R1, R1, #0
	LDI	R0, FRAC2
; fourth shift (2.4)
	JSR	SHIFT
	STI	R1, FRAC2
	LDI	R0, FRAC1
	LDI	R1, FRAC2

; Add results to simulate multiplication
	ADD	R3, R0, R3

; adjust for math error
	ADD	R1, R1, #-1

; follow algorithm as laid out by pdf and
; knowledge of multiplication algorithm from
; lab 3
; add R3 to R0
MULTIPLY ADD	R0, R0, R3
; decrement counter per addition			
	ADD	R1, R1, #-1
	BRp	MULTIPLY
; store finished fraction/mantiss in MANTFIN
	STI	R0, MANTFIN

; mask the result 
	LD	R4, MULTMASK

; combine result and mask
	AND	R5, R4, R0

; checks to see if the leading digit is
; in the mask
	BRz	SKIP

; add one to exponent
	LDI	R6, EXPOFIN
	ADD	R6, R6, #1
	STI	R6, EXPOFIN

; shift numbers for the mantiss/fraction
; first shift (3.1)
	AND	R1, R1, #0
	JSR	SHIFT
	STI	R1, MANTFIN
; second shift (3.2)
	LDI	R0, MANTFIN
; reset first register
SKIP	AND	R1, R1, #0
	JSR	SHIFT
	STI	R1, MANTFIN
; third shift (3.3)
	LDI	R0, MANTFIN
; reset first register
	AND	R1, R1, #0
	JSR	SHIFT
; remove leading 1 from result
	LD	R2, MASK
	NOT 	R2, R2
	AND	R1, R1, R2
	STI	R1, MANTFIN

; combining the multiplicated result of the
; fractions/mantisses and the added result of
; the exponent to get the full number
	JSR 	CLEAR
	LDI	R0, EXPOFIN
	LDI	R1, MANTFIN

; make a counter that will tick 10 times
	ADD	R2, R2, #10
	JSR	COMB
	ADD	R3, R0, R1
	STI	R3, FINALNUM

; print out a newline
	LEA	R0, NEWLINE
	PUTS

	JSR 	CLEAR

; make several different counters
	ADD	R2, R2, #1
	ADD	R3, R3, #6
	ADD	R4, R4, #15
	ADD	R4, R4, #1
	LDI	R1, FINALNUM

; print string of 'Product:'
	LEA	R0, MULTSTRING
	PUTS

; print the final floating point number
	JSR	PRIFLO

; print out a newline
	LEA	R0, NEWLINE
	PUTS

; restart the program
	JSR	START
		
; stop the processor
	HALT


; data declarations follow below

; variables

ONENUM1:	.FILL	0
ONENUM2:	.FILL	0
TWONUM1:	.FILL	0
TWONUM2:	.FILL	0
LOOPS:		.FILL	0
SIGN:		.FILL	0
SIGN1:		.FILL	0
SIGN2:		.FILL	0
POSNEG:		.FILL	0
MEMR7		.FILL	0
COUNT:		.FILL	#25
NEG45:		.FILL	#-45
NEG48:		.FILL	#-48
POS48:		.FILL	#48
MASK:		.FILL	x0400
MULTMASK:	.FILL	x2000
NUMBER1:	.FILL	x4100
NUMBER2:	.FILL	x4101
EXPO1:		.FILL	x4102
FRAC1:		.FILL	x4103
EXPO2:		.FILL	x4104
FRAC2:		.FILL	x4105
RESULT1:	.FILL	x4106
RESULT2:	.FILL	x4107
EXPOFIN:	.FILL	x4108
MANTFIN:	.FILL	x4109
FINALNUM:	.FILL	x410A
NEGS:		.FILL	X8000

; strings
NEWLINE:	.STRINGZ 	"\n";
GREETING1:	.STRINGZ	"Enter 1st number: "
GREETING2:	.STRINGZ	"Enter 2nd number: "
SPACE:		.STRINGZ	" "
FLOATPOINT1:	.STRINGZ	"Floating Point 1: "
FLOATPOINT2:	.STRINGZ	"Floating Point 2: "
MULTSTRING:	.STRINGZ	"Product:   "

; clear all registers
CLEAR:	
	AND	R0, R0, 0
	AND	R1, R0, 0
	AND	R2, R0, 0
	AND	R3, R0, 0
	AND	R4, R0, 0
	AND	R5, R0, 0
	AND	R6, R0, 0
	RET

; convert to values
CONV:	
	ST	R7, MEMR7
	LD	R6, NEG48
	ADD	R1, R1, R6			
	ADD	R2, R2, R6
; create a counter that will tick 9 times
	ADD	R3, R3, #9
	ADD	R5, R1, #0
; add to create the ten's place
MULTI	ADD	R1, R5, R1
	ADD	R3, R3, #-1
	BRnp	MULTI
	ADD	R4, R1, R2
	RET

; create counter that will move num to the left
FLOAT:	
; decrement counter in R4
	ADD 	R4, R4, #-1
; move to left
	ADD 	R1, R1, R1
	AND	R3, R1, R2
	BRz	FLOAT
	RET

; move the exponent
COMB:	
	ADD	R0, R0, R0
	ADD	R2, R2, #-1
	BRp	COMB
	RET

; loop through the final floating point number
; to see if 1 or 0 should be printed at each
; result
PRIFLO: 
	ST	R7, LOOPS
LOOPER	ADD	R1, R1, #0
; print 1
	BRn	PRINT1
; print 0
	BR	PRINT0
; move to left to loop again
SPOT1	ADD 	R1, R1, R1
; countdown for space left on the number
	ADD	R2, R2, #-1
; print space for each 'location' and then
; repeat two more times (sign, exponent, mantiss)
	BRz	PRINTSPA1
SPOT2	ADD	R3, R3, #-1
	BRz	PRINTSPA2
SPOT3	ADD	R4, R4, #-1
	BRp	LOOPER
; give R7 original memory location		
	LD	R7, LOOPS
	RET

; print a 1
PRINT1  AND	R0, R0, #0
	ADD	R0, R0, #1
; convert back to ASCII
	LD	R6, POS48
	ADD	R0, R0, R6
	PUTC
	BR	SPOT1
; print a 0
PRINT0	AND	R0, R0, #0
; convert back to ASCII
	LD	R6, POS48
	ADD	R0, R0, R6
	PUTC
	BR	SPOT1
; print space
PRINTSPA1 LEA	R0, SPACE
	PUTS
	BR 	SPOT2
; print space
PRINTSPA2 LEA	R0, SPACE
	PUTS
	BR	SPOT3

; shift numbers to the left
SHIFT	ADD 	R1, R1, #1
	ADD 	R0, R0, #-2
	BRp	SHIFT
	RET

; end of code
	.END
