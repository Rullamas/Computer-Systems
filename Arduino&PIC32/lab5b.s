/* http://tigcc.ticalc.org/doc/gnuasm.html */
	
	
#include <WProgram.h>
/* define all global symbols here */
.global myprog	
.text	
.set noreorder

.ent myprog 
/* directive that marks symbol 'main' as function in ELF   
 * output
           */
myprog:
	
	jal		initTmp		/* initialize temp array 0*/
	nop
	
	/* Print original message */
	la      $a0,Serial 			
	la 		$a1,msg 			
	jal     _ZN5Print7printlnEPKc
	nop 
	
	la $a0, msg
	move $s0, $a0
	
strLen:                 #gets the length of the string
	lb      $t0, str($t2)   #loads the value into t0
	add     $t2, $t2, 1
	bne     $t0, $zero, strLen

	li      $v0, 11         #loads imediate value
	Loop:
	sub     $t2, $t2, 1
	la      $t0, str($t2)   #loads the value into $t0
	lb      $a0, ($t0)
	syscall
	bnez    $t2, Loop
	li      $v0, 10          #done executing
	syscall
	nop

/********************************************************/
/* Function: Initialize temp array with zeros */
/********************************************************/
initTmp:
	addi	$t7, $0, 10
	la		$t9, tmp
	nop
	lb		$t8, zChar
	nop
inloop:
	sb		$t8, 0($t9)
	addi	$t9, $t9, 1
	addi	$t7, $t7, -1
	beq		$t7, $0, indone
	nop
	j		inloop
	nop

indone:
	jr		$ra
	nop

	/* return to main */
	
/********************************************************/
/* Function: Push in stack */
/********************************************************/
push:
	#add 		$sp, $sp, -4
	#sw 		$r1, 0($sp)
	#jr 			$r31
	#nop

/********************************************************/
/* Function: Pop from stack */
/********************************************************/
pop:
	#lw			$r1, 0($sp)
	#add		$sp, $sp, 4
	#jr			$r31
	#nop



.end myprog 
/* directive that marks end of 'main' function and registers
           
 * size in ELF output
           */
	

.data
space:	.ascii " "
#newLine: ascii "\n"
tChar:	.byte	0
zChar:	.byte	0					/* Used to clear the temporary array */
msg:	.ascii	"hello world\0"		/* will contain message to be reversed */ 	
tmp:	.space 	10					/* temporary array to contain reversed word */



