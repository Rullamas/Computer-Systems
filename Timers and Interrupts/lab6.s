/* Push a register*/
.macro  push reg
sw      \reg, ($sp)
addi    $sp, $sp, -4
.endm

/* Pop a register*/
.macro  pop reg
addi    $sp, $sp, 4
lw      \reg, ($sp)
.endm
	
#include <WProgram.h>

/* Jump to our customized routine by placing a jump at the vector 4 interrupt vector offset */
.section .vector_4,"xaw"
	j T1_ISR

/* The .global will export the symbols so that the subroutines are callable from main.cpp */
.global PlayNote
.global SetupPort
.global SetupTimer 

/* This starts the program code */
.text
/* We do not allow instruction reordering in our lab assignments. */
.set noreorder

	

/*********************************************************************
 * myprog()
 * This is where the PIC32 start-up code will jump to after initial
 * set-up.
 ********************************************************************/
.ent myprog

/* This should set up Port D pin 8 for digital output */
SetupPort:
	li		$t9, 0x8
	li		$t8, 0xbf8860c0		# load address of TRISD into $t8
	sw		$t9, 4($t8)		# storing mask into TRISD making it an output
	
	jr $ra
	nop

/* This should configure Timer 1 and the corresponding interrupts,
 * but it should not enable the timer.
 * 4 = clear, 8 = set, 12 = toggle
 */
SetupTimer:	
	li		$t9, 0xFFFF		# clear T1CON
	li		$t8, 0xBF800600
	sw		$t9, 4($t8)
	li		$t7, 0x30	# set prescalar (T1CKPS) to '11' mask is 24
	sw		$t7, 8($t8)
	li		$t6, 0xFFFF
	li		$t8, 0xBF800610		# clear counter (TMR1)
	sw		$t6, 4($t8)
	li		$t5, 0x163
	li		$t8, 0xBF800620		# set period value (PR1)
	sw		$t5, 8($t8)
	li		$t4, 0b10000		# set interrupt priority (IPC1) to 4
	li		$t8, 0xBF8810A0
	sw		$t4, 8($t8)
	/*li		$t3, 0x90		# clear prior interrupts (T1IF)
	*li		$t8, 0xBF881030
	*sw		$t3, 4($t8)
	*li		$t2, 0x90		# enable interrupts (set T1IE)
	*li		$t8, 0xBF881060
	*sw		$t2, 8($t8)*/
	sw		$t9, IEC0SET
	jr $ra
	nop

	
/* This should take the following arguments:
*  $a0 = tone frequency
*  $a1 = tone duration
*  $a2 = full note duration ($a2 - $a1 is the amount of silence after the tone)
*/
PlayNote:
	
	push $ra
	push $s0
	push $s1
	li		$t8, 0xBF800620		
	li		$t7, 156250
	beqz 	$a0, ZeroReg
	div		$t7, $a0		# calculate period
	mflo	$t6
	sw		$t6, PR1		# set period
ZeroReg:
	li		$t1, 0x8000		# set timer on (t1)
	li		$t8, 0xBF800600
	sw		$t1, 8($t8)
	move	$a0, $a1
	jal		delay	 		# call delay function
	nop
	li		$t1, 0x0000		# set timer off (t1)
	li		$t8, 0xBF800600
	sw		$t1, 4($t8)
	jal		delay			# call delay function
	nop	
	pop $s1
	pop $s0
	pop $ra
	
	jr $ra
	nop
	
	
/* The ISR should toggle the speaker output value and then clear and re-enable the interrupts. */
T1_ISR:
	
	push	$a0					# push registers
	push	$a1
	push	$a2
	push	$a3
	push	$t0
	push	$t1
	push	$t2
	push	$t3
	push	$t4
	push	$t5
	push	$t6
	push	$t7
	push	$t8
	push	$t9
	li		$t9, 0x8
	li		$t7, 0xbf8860d0		# portd
	sw		$t9, 12($t7)		# toggle pin 9
	li		$t6, 0xFFFF
	li		$t8, 0xBF800610		# clear counter (TMR1)
	sw		$t6, 4($t8)			
	li		$t3, 0x90			# clear prior interrupts (T1IF)
	li		$t8, 0xBF881030
	sw		$t3, 4($t8)			# clear t1if
	pop		$t9					# pop registers
	pop		$t8
	pop		$t7
	pop		$t6
	pop		$t5
	pop		$t4
	pop		$t3
	pop		$t2
	pop		$t1
	pop		$t0
	pop		$a3
	pop		$a2
	pop		$a1
	pop		$a0
	eret
	
	

.end myprog /* directive that marks end of 'myprog' function and registers
           * size in ELF output
           */

