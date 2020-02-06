.global main

.equ READERROR, 0
	
main:

welcome:
	LDR r0, =strWelcomePrompt
	BL printf

mainloop:
	BL prompt

	
prompt:
	MOV r12,r14
	STMFD r13!,{r12}
	LDR r0, =strIntegerPrompt1
	@BL printf
	@BL get_int_input
	@LDR r0, =strIntegerPrompt2
	@BL printf
	@BL get_int_input
	@B intsuccess
	LDMFD r13!,{r15}
	
get_int_input:
	@PUSH {lr}
	LDR r0, =numInputPattern
	LDR r1, =intInput
	BL scanf
	cmp r0, #READERROR
	BEQ intreaderror
	LDR r1, =intInput
	LDR r1, [r1]
	PUSH {r1}
	@POP {PC}

intreaderror:
	LDR r0, =strOutputNum
	BL printf
	B myexit

intsuccess:
	LDR r0, =strOutputNum
	POP {r1}
	BL printf
	LDR r0, =strOutputNum
	POP {r1}
	BL printf
	B myexit
	
myexit:
	MOV r7, #0x01
	SVC 0
		
	
.data
.balign 4	
strInputPattern: .asciz "%[^\n]"	

.balign 4
numInputPattern: .asciz "%d"

.balign 4
strOutputNum: .asciz "The number value is: %d \n"

.balign 4
strWelcomePrompt: .asciz "Thank you for using a simple calculator.\n"

.balign 4
strOperandPrompt: .asciz "Input operand (p/m/s/d) for (plus/multiply/subtract/divide)\n"

.balign 4
strIntegerPrompt1: .asciz "Input first positive integer: "

.balign 4
strIntegerPrompt2: .asciz "Input second positive integer: "

.balign 4
strInputError:	 .skip 100*4

.balign 4
intInput:	 .word 0

	
.global printf
.global scanf
