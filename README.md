ECE382_Lab1
===========

##Lab1

####Objective

Basic Calculator -- Takes in an array containing hex bytes. The program converts the hex bytes into values and
operations for calculating. The calculator performs the correct operation and then stores
all values into memory

####Operations
0x11 - Add
0x22 - Subtract
0x44 - Clear
0x55 - End

####Flow Chart and Pseudocode

See prelab turn-in.  Forgot to take a picture before turning in.

####Code

```
; this array is the array that the calculator works with
eqArray	.byte	0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0xDD, 0x44, 0x08, 0x22, 0x09, 0x44, 0xFF, 0x22, 0xFD, 0x55
Add:	.equ	0x11	;addition operation constant
Sub:	.equ	0x22	;subtraction operation constant
Clear:	.equ	0x44	;clearing operation constant

;-------------------------------------------------------------------------------
RESET mov.w #__STACK_END,SP ; Initialize stackpointer
StopWDT mov.w #WDTPW|WDTHOLD,&WDTCTL ; Stop watchdog timer

;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

          mov.w	#eqArray, R5	;points at test string
          mov.w	#store, R10 ;start of storage addresses
          mov.b	@R5+, R6	;first operand
main
          mov.b	@R5+, R7	;opcode
          mov.b	@R5+, R8	;second operand
```
This section of code sets up the program.  eqArray is the array holding the equation in hexadecimal.  The three .equ lines create constants so that magic numbers need not be used.  The three first lines in the main loop set up storage of the hex equation and memory locations.  The main loop is used after a clear operation to reset the program to read the next section of the equation.

```
;-------------------------------------------------------------------------------
; Checks to see if the operation is an 11, and if so, adds the two operands together.
; If not, jumps to the next section to check for subtraction
;-------------------------------------------------------------------------------
checkAdd
          cmp.b	#Add, R7
          jnz	checkSub
          mov.b	R6, R9
          add.b	R8, R9
          jnc	storeAdd
          mov.w	#0xFF, R9	      ;B functionality, adds 255 to memory if over 255
storeAdd
          mov.b	R9, 0(R10)
          inc.w	R10
          jmp	nonClearOp
```
This section of code works with the Add function of the Calculator.  When an 0x11 is read by the program, it adds the two operands together and stores the result in memory.  If not, it moves on to check if the program should do a subtraction operation.  This portion of code also contains part of the B functionality of the program.  If the two operands add up to more than 255 in decimal, the max value of 255 will be stored into memory.

```
;-------------------------------------------------------------------------------
; Checks to see if the operation is an 22, and if so, subtracts the two operands.
; If not, jumps to the next section to check for a clear function
;-------------------------------------------------------------------------------
checkSub
          cmp.b	#Sub, R7
          jnz	checkClear
          mov.b	R6, R9
          sub.b	R8, R9
          cmp.b	R8, R6
          jl	storeSub	    ;B functionality, adds 0 to memory if under 0
          mov.b	R9, 0(R10)
          inc.w	R10
          jmp	nonClearOp
storeSub
          mov.b	#0x00, R9
          mov.b	R9, 0(R10)
          inc.w	R10
          jmp	nonClearOp
```
This section of code works with the Subtract function of the Calculator.  When an 0x22 is read by the program, it subtracts the second operand from the first operand and stores the result in memory.  If not, it moves on to check if the program should do a clear operation.  This portion of code also contains part of the B functionality of the program.  If the subtraction results in a value less than 0 in decimal, the min value of 0 will be stored into memory.

```
;-------------------------------------------------------------------------------
; Checks to see if the operation is an 44, and if so, adds a 00 to memory
;-------------------------------------------------------------------------------
checkClear
          cmp.b	#Clear, R7
          jnz	end	          ;operation is a 55, end program
          mov.b	#0x00, R9
          mov.b	R9, 0(R10)
          inc.w	R10
          mov.b	R8, R6
          jmp	main
```
This section of the program works with the Clear function of the calculator.  When a 0x44 is read by the program, it writes 0x00 to memory and starts the program over with the next part of the equation.  If not, this means a 0x55 is being read and the equation is at an end.  The clearing operation required a different approach to reseting the program and thus jumped back to main for reset.

```
;-------------------------------------------------------------------------------
; Resets the program after a non clearing operation
;-------------------------------------------------------------------------------
nonClearOp
          mov.b	R9, R6
          mov.b	@R5+, R7
          mov.b	@R5+, R8
          jmp	checkAdd
```
This section of code resets the program after non clearing operations.

####Debugging/Testing

I started the program by using the basic outline given in the handout for lab 1 help.  That gave me the basic idea of how I would write the program.  However, the handout had different functions than what we needed in this lab so I had to write those functions myself, as well as figure out how to get B functionality and reset the program depending on the type of operation being done.  

I didn't have too many problems with this program surprisingly.  I wrote the code I believed would work and it worked.  The hard part of the program for me was getting the B functionality.  I had to go through multiple iterations of writing and testing code to get it working.  

Unfortunately, due to time constraints, other homework, and my lack of creativity with this particular type of programming, I was not able to get the A functionality of the code working.

I ran the test cases given by the lab handout for the basic program and for the B functionality.  Each test produced the correct result, showing that my basic program worked and that my B functionality worked.

Documentation:  Class notes and handouts, Lab 1 handout, C2C Taylor Bodin's readme as a guideline
