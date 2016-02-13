/* http://tigcc.ticalc.org/doc/gnuasm.html */
	
	
#include <WProgram.h>

	

/* define all global symbols here */
	
.global myprog

	

/* define which section (for example "text")
     
 * does this portion of code resides in. Typically,
     
 * all your code will reside in .text section as
     
 * shown below.
    */
	
.text

	

/* This is important for an assembly programmer. This
     
 * directive tells the assembler that don't optimize
     
 * the order of the instructions as well as don't insert
     
 * 'nop' instructions after jumps and branches.
    */
	
.set noreorder



/*********************************************************************
 
 * main()
 
 * This is where the PIC32 start-up code will jump to after initial
 
 * set-up.
 
********************************************************************/



.ent myprog 
/* directive that marks symbol 'main' as function in ELF
           
 * output
           */



myprog:


loop:
	

/* load register a0 with Serial object address */
	
la      $a0,Serial
	

/* load register a1 with string constant address */
	
la 	$a1,hello
	

/* call the C++ function to do Serial.println("Hello, world!") */
	
/* notice that the symbol name is "mangled" in C++ */
        
jal     _ZN5Print7printlnEPKc
        
nop
        j       
loop
        nop
	

	
/* return to main */
	


.end myprog 
/* directive that marks end of 'main' function and registers
           
 * size in ELF output
           */
	

	

.data
hello:	
	

.ascii "Hello, world!\0"

