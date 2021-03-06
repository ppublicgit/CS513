@ Paul Abers
@ Simple Calculator
@ CS513 Lab 2
	

.global main

.equ READERROR, 0
	
main:

welcome: @ welcome message for user
	LDR r0, =strWelcomePrompt
	BL printf
	B mainloop

mainloop: @ mainloop for simple calculator operation
	BL promptInt1
	BL promptInt2
	BL promptOperand
	BL handleCalculation

promptInt1: @ prompt 1 to get first input integer
	PUSH {LR}
	LDR r0, =strIntegerPrompt1
	BL printf
	BL get_int_input1
	POP {LR}
	PUSH {r1}
	MOV PC, LR

promptInt2: @ prompt 2 to get second input integer
	PUSH {LR}
	LDR r0, =strIntegerPrompt2
	BL printf
	BL get_int_input2
	POP {LR}
	PUSH {r1}
	MOV PC, LR
	
promptOperand: @ prompt to get operand for calculator
	PUSH {LR}
	LDR r0, =strOperandPrompt
	BL printf
	BL get_operand_input
	POP {LR}
	PUSH {r1}
	MOV PC, LR
	
get_int_input1: @ get the first integer
	PUSH {LR}
	LDR r0, =numInputPattern
	LDR r1, =intInput
	BL scanf
	cmp r0, #READERROR
	BEQ intReadError1
	LDR r1, =intInput
	LDR r1, [r1]
	CMP r1, #0
	BLT intReadError1
	POP {LR}	
	MOV PC, LR

get_int_input2: @ get the second integer
	PUSH {LR}
	LDR r0, =numInputPattern
	LDR r1, =intInput
	BL scanf
	cmp r0, #READERROR
	BEQ intReadError2
	LDR r1, =intInput
	LDR r1, [r1]
	CMP r1, #0
	BLT intReadError2
	POP {LR}	
	MOV PC, LR

get_operand_input: @ get the operand integer
	PUSH {LR}
	LDR r0, =numInputPattern
	LDR r1, =intInput
	BL scanf
	cmp r0, #READERROR
	BEQ intOperandError
	LDR r1, =intInput
	LDR r1, [r1]
	CMP r1, #1
	BLT intOperandError
	CMP r1, #4
	BGT intOperandError
	POP {LR}
	MOV PC, LR

handleCalculation: @ handle the calculation by branchign to correct operand subprocess
	POP {r0}
	CMP r0, #4
	BEQ division
	CMP r0, #3
	BEQ multiplication
	CMP r0, #2
	BEQ subtraction
	CMP r0, #1
	BEQ addition
	
addition: @ perform addition of two integers
	LDR r0, =strAddition
	POP {r2}
	POP {r1}
	PUSH {r2}
	PUSH {r1}
	BL printf
	POP {r1}
	POP {r2}
	ADDS r3, r2, r1
	PUSH {r3}
	BVS overflowError
	B printResult

subtraction: @ perform subtraction of two integers
	LDR r0, =strSubtraction
	POP {r2}
	POP {r1}
	PUSH {r2}
	PUSH {r1}
	BL printf
	POP {r1}
	POP {r2}
	SUBS r3, r1, r2
	PUSH {r3}
	BVS overflowError
	B printResult

multiplication: @ perform multiplication of two integers
	LDR r0, =strMultiplication
	POP {r2}
	POP {r1}
	PUSH {r2}
	PUSH {r1}
	BL printf
	POP {r1}
	POP {r2}
	UMULL r4, r3, r2, r1
	PUSH {r4}
	CMP r3, #0
	BGT overflowError
	B printResult
	
division: @ perform division of two integers
	LDR r0, =strDivision
	POP {r2}
	CMP r2, #0
	BEQ zeroDivisionError
	POP {r1}
	PUSH {r2}
	PUSH {r1}
	BL printf
	POP {r1}
	POP {r2}
	AND r3, r3, #0
	BL divisionBySubtraction
	PUSH {r1}
	PUSH {r3}
	BGT overflowError
	B printResultDivision

divisionBySubtraction: @ loop for performing division by subtraction
	ADD r3, r3, #1
	SUBS r1, r1, r2
	CMP r1, #0
	BGT divisionBySubtraction
	BEQ perfectDivisor
	SUB r3, #1
	ADD r1, r1, r2
	MOV PC, LR
	
perfectDivisor: @ branch to handle no remainder
	MOV PC, LR
	
intReadError1: @ integer read errror for first integer input
	LDR r0, =strErrorInt1
	BL printf
	LDR r0, =strInputPattern
	LDR r1, =strInputError
	BL scanf
	POP {LR}
	POP {LR}
	SUB LR, LR, #4
	MOV PC, LR
	
intReadError2: @ integer read errror for second integer input
	LDR r0, =strErrorInt2
	BL printf
	LDR r0, =strInputPattern
	LDR r1, =strInputError
	BL scanf
	POP {LR}
	SUB LR, LR, #4
	MOV PC, LR

intOperandError: @ operand read for operand input
	LDR r0, =strErrorOperand
	BL printf
	LDR r0, =strInputPattern
	LDR r1, =strInputError
	BL scanf
	POP {LR}
	SUB LR, LR, #4
	MOV PC, LR

zeroDivisionError: @ zero division error handler
	LDR r0, =strDivisionError
	BL printf
	LDR r0, =strInputPattern
	LDR r1, =strInputError
	BL scanf
	B continueCheck

overflowError: @ handle overflow error message
	LDR r0, =strOverflowError
	BL printf
	LDR r0, =strInputPattern
	LDR r1, =strInputError
	BL scanf
	B printResult

continueCheckError: @ handle incorrect continue flag 
	LDR r0, =strContinueCheckError
	BL printf
	LDR r0, =strInputPattern
	LDR r1, =strInputError
	BL scanf
	B continueCheck

continueCheck: @ continue using check 
	LDR r0, =strContinueCheck
	BL printf
	LDR r0, =numInputPattern
	LDR r1, =intInput
	BL scanf
	cmp r0, #READERROR
	BEQ continueCheckError
	LDR r1, =intInput
	LDR r1, [r1]
	B handleContinue

handleContinue:	@ branch back to the mainloop to continue using simple calculator
	CMP r1, #0
	BEQ myexit
	CMP r1, #1
	BEQ mainloop
	B continueCheckError
	
printResult: @ print result of calculation
	LDR r0, =strResult
	POP {r1}
	BL printf
	B continueCheck

printResultDivision: @ print result for division of calculation
	LDR r0, =strResultDivision
	POP {r1}
	POP {r2}
	BL printf
	B continueCheck
	
myexit: @ exit the program
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
strOperandPrompt: .asciz "Input operand (1:addition, 2:subtraction, 3:multiplication, 4:division): "

.balign 4
strIntegerPrompt1: .asciz "Input first positive integer: "

.balign 4
strIntegerPrompt2: .asciz "Input second positive integer: "

.balign 4
strErrorInt1: .asciz "Error reading integer 1. Must be a positive integer value between [0, 2147483647] . Please try again.\n"

.balign 4
strErrorInt2: .asciz "Error reading integer 2. Must be a positive integer value between [0, 2147483647] . Please try again.\n"

.balign 4
strErrorOperand: .asciz "Error reading operand. Must be 1, 2, 3, or 4. Please try again.\n"

.balign 4
strDivisionError: .asciz "Error, cannot divide by zero. Please try again.\n"

.balign 4
strOverflowError: .asciz "Warning, overflow has occurred.\n"

.balign 4
strContinueCheckError: .asciz "Error reading continue option. Must be either 0 for stop or 1 for continue.\n"

.balign 4
strContinueCheck: .asciz "Continue with another calculation? 0:stop, 1:continue.\n"

.balign 4
strAddition: .asciz "(+) %d %d "

.balign 4
strSubtraction: .asciz "(-) %d %d "

.balign 4
strMultiplication: .asciz "(*) %d %d "

.balign 4
strDivision: .asciz "(/) %d %d "

.balign 4
strResult: .asciz "= %d \n"

.balign 4
strResultDivision: .asciz "= Quotient: %d and Remainder: %d\n"
	
.balign 4
strInputError:	 .skip 100*4

.balign 4
intInput:	 .word 0

	
.global printf
.global scanf
