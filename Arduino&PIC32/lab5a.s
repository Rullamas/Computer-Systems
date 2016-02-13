#####################################################
### lab 5										  ###
#####################################################

# This file has three example subroutines:
#	1. a subroutine to enable LED5
#	2. a subroutine to turn on LED5
#	3. a subroutine to turn off LED5 

# In myprog, first the enable subroutine is called to make LED5 an output
# then, a loop is initiated where we turn the LED on by calling a subroutine,
# then we print a message to the terminal, then we turn the LED off.
# But, the loop happens so quickly, we don't see it blinking! Thats why we 
# need to create a mydelay subroutine.



.global myprog 										# puts the symbol myprog into the symbol table 

.text												# specifies the instruction part of your program	

.set noreorder										# prevents the assembler from reordering the instructions

.ent myprog											# specifies where the entry to myprog starts

myprog:												# label of the address for myprog

	jal 	EnableLED								# jump to subroutine to enable LED 5 (similar to JSR in LC3)
	nop												

	j		blink									# jump to blink loop
	nop

blink:												# loop continually blinks LED on and off for set inverval
	
	jal		LEDon									# turn on LED 5
	nop
	
	la		$a0,Serial								# print message "on!" to terminal
	la		$a1,test
	jal     _ZN5Print7printlnEPKc     
	nop
	
	li		$a0, 1000								# if value 1000 stored to be passed into myDelay, delay should be 1s long
	jal		myDelay									# jump to myDelay subroutine to delay for xxxxx seconds (leave LED on)
	nop
	
	jal		LEDoff									# turn off LED 5
	nop

	la		$a0,Serial								# print message "off!" to terminal
	la		$a1,test2        
	jal     _ZN5Print7printlnEPKc     
	nop	
	
	li		$a0, 1000
	jal		myDelay									# jump to myDelay subroutine to delay for xxxxx seconds (leave LED off)
	nop
	
	j      blink									# loop
	nop
	
################################
## Subroutine to enable LED 5 ##
################################
EnableLED:
	li 		$t9, 0x1								# li = pseudo op to load an immediate value into a register, 1 => $t9 
	li 		$t8, 0xbf886140  						# load address of TRISF into $t8 
	sw 		$t9, 4($t8)								# store $t9 into address defined by $t8 plus an offset of 4
													# this clears TRISF, making LED5 an output
	jr 		$ra										# jr is the return instruction (like RET in LC3), 
													# $ra is the return address (like R7 in LC3)
	nop


## subroutines: ##
	
###########################
# turn on led5 subroutine #
###########################
LEDon:
	li 		$t9, 0x1
	li 		$t8, 0xbf886150							# load address of PORTF into $t8 
	sw 		$t9, 8($t8)								# store $t9 into PORTF with an offset of 8 to turn on LED5
	jr		$ra
	nop
	
###########################
# turn on led5 subroutine #
###########################
LEDoff:
	li 		$t9, 0x1
	li 		$t8, 0xbf886150
	sw 		$t9, 4($t8)								# store $t9 into PORTF with an offset of 4 to turn off LED5	
	jr		$ra
	nop	

#####################################
# delay for time specified in blink #
#####################################
myDelay:
	li		$t9, 26900000							# load instruction count into t9

outer:												# outer loop counts down miliseconds to delay for set time period
	addi	$a0, $a0, -1							# decrement counter
	bgtz	$a0, ms									# if cont =/= 0, branch to 1 milisecond loop
	nop
	beqz	$a0, cont								# if count = 0, return to blink loop
	nop
cont:												
	jr		$ra
	nop
ms:													# ms loop creates delay of 1 milisecond
	addi	$t9, $t9, -1							# decrement counter (holds 40,000 originally)
	bgtz	$t9, ms									# if counter =/= 0, branch to ms
	nop	
	j		outer									# if counter = 0, branch to outer loop
	nop
	
.end myprog 										# end of myprog

.data												# data part of the program
test:		.ascii	"on!\0"
test2:		.ascii	"off!\0"
outerCount:	.word	1000
zero:		.word	0

