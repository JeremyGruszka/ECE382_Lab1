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
This section of code is sets up the program.  eqArray is the array holding the equation in hexadecimal.  The three .equ lines create constants so that magic numbers need not be used.


I ran the test cases for the basic program and for the B functionality.  Each test produced the correct result, showing 
that my basic program worked and that my B functionality worked.

Documentation:  Class notes and handouts, Lab 1 handout, C2C Taylor Bodin's readme as a guideline
