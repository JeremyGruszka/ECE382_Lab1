;-------------------------------------------------------------
; Lab1
; Dr. Coulston, 08 SEP 2014
;
; Calculator
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

eqArray		.byte	0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0xDD, 0x44, 0x08, 0x22, 0x09, 0x44, 0xFF, 0x22, 0xFD, 0x55
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
; Checks to see if the operation is an 11, and if so, adds the two operands together
;-------------------------------------------------------------------------------
check11
			cmp.b	#0x11, R7
			jnz		check22
			mov.b	R6, R9
			add.b	R8, R9
			jnc		storeAdd
			mov.w	#0xFF, R9	;B functionality, adds 255 to memory if over 255
storeAdd
			mov.b	R9, 0(R10)
			inc.w	R10
			jmp		non44op



;-------------------------------------------------------------------------------
; Checks to see if the operation is an 22, and if so, subtracts the two operands
;-------------------------------------------------------------------------------
check22
			cmp.b	#0x22, R7
			jnz		check44
			mov.b	R6, R9
			sub.b	R8, R9
			cmp.b	R8, R6
			jl		storeSub	;B functionality, adds 0 to memory if under 0
			mov.b	R9, 0(R10)
			inc.w	R10
			jmp		non44op
storeSub
			mov.b	#0x00, R9
			mov.b	R9, 0(R10)
			inc.w	R10
			jmp		non44op



;-------------------------------------------------------------------------------
; Checks to see if the operation is an 44, and if so, adds a 00 to memory
;-------------------------------------------------------------------------------
check44
			cmp.b	#0x44, R7
			jnz		end			;operation is a 55, end program
			mov.b	#0x00, R9
			mov.b	R9, 0(R10)
			inc.w	R10
			mov.b	R8, R6
			jmp		main



;-------------------------------------------------------------------------------
; Resets the program after a non 44 operation
;-------------------------------------------------------------------------------
non44op
			mov.b	R9, R6
			mov.b	@R5+, R7
			mov.b	@R5+, R8
			jmp		check11




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
