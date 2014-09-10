;-------------------------------------------------------------
; Lab1
; Jeremy Gruszka, 08 SEP 2014
;
; Calculator -- Takes in an array containing hex bytes.  The program converts the hex bytes into values and
;				operations for calculating.  The calculator performs the correct operation and then stores
;				all values into memory
;-------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
                                            ; section

            .data
            .bss	store, 0x0200
            .text
            
; this array is the array that the calculator works with
eqArray		.byte	0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0xDD, 0x44, 0x08, 0x22, 0x09, 0x44, 0xFF, 0x22, 0xFD, 0x55

Add:		.equ	0x11	;addition operation constant
Sub:		.equ	0x22	;subtraction operation constant
Clear:		.equ	0x44	;clearing operation constant
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------

			mov.w	#eqArray, R5	;points at test string
			mov.w	#store, R10 ;start of storage addresses
			mov.b	@R5+, R6	;first operand
main
			mov.b	@R5+, R7	;opcode
			mov.b	@R5+, R8	;second operand



;-------------------------------------------------------------------------------
; Checks to see if the operation is an 11, and if so, adds the two operands together.
; If not, jumps to the next section to check for subtraction
;-------------------------------------------------------------------------------
checkAdd
			cmp.b	#Add, R7
			jnz		checkSub
			mov.b	R6, R9
			add.b	R8, R9
			jnc		storeAdd
			mov.w	#0xFF, R9	;B functionality, adds 255 to memory if over 255
storeAdd
			mov.b	R9, 0(R10)
			inc.w	R10
			jmp		nonClearOp



;-------------------------------------------------------------------------------
; Checks to see if the operation is an 22, and if so, subtracts the two operands.
; If not, jumps to the next section to check for a clear function
;-------------------------------------------------------------------------------
checkSub
			cmp.b	#Sub, R7
			jnz		checkClear
			mov.b	R6, R9
			sub.b	R8, R9
			cmp.b	R8, R6
			jl		storeSub	;B functionality, adds 0 to memory if under 0
			mov.b	R9, 0(R10)
			inc.w	R10
			jmp		nonClearOp
storeSub
			mov.b	#0x00, R9
			mov.b	R9, 0(R10)
			inc.w	R10
			jmp		nonClearOp



;-------------------------------------------------------------------------------
; Checks to see if the operation is an 44, and if so, adds a 00 to memory
;-------------------------------------------------------------------------------
checkClear
			cmp.b	#Clear, R7
			jnz		end			;operation is a 55, end program
			mov.b	#0x00, R9
			mov.b	R9, 0(R10)
			inc.w	R10
			mov.b	R8, R6
			jmp		main



;-------------------------------------------------------------------------------
; Resets the program after a non clearing operation
;-------------------------------------------------------------------------------
nonClearOp
			mov.b	R9, R6
			mov.b	@R5+, R7
			mov.b	@R5+, R8
			jmp		checkAdd




end
			jmp		end

;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect 	.stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
