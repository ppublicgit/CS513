@ Paul Abers
@ Auto Index
@ CS513 Lab 3


.global main

.equ READERROR, 0

.equ Len, 10 @length of arrays as 10




main:

welcome: @ welcome message for user
	LDR r0, =strWelcomePrompt
	BL printf
	B mainloop

mainloop: @ main loop that runs the code
    LDR r0, =A@-4 @register r0 points at array A
    LDR r1, =B@-4 @register r1 points at array B
    LDR r2, =C@-4 @register r2 points at array C
    ADD r0, #-4 @point before array A to allow preindexing auto indexing
    ADD r1, #-4 @point before array B to allow preindexing auto indexing
    ADD r2, #-4 @point before array C to allow preindexing auto indexing
    MOV r5, #Len @register r5 is loop counter
    BL printarrays
    BL userInput
    B exit

printarrays:    @print arrays
    PUSH {lr} @push lr to stack
    PUSH {r0, r1, r2, r5}
    BL printA @branch to print array A
    POP {r0, r1, r2, r5}
    PUSH {r0, r1, r2, r5}
    BL printB @branch to print array B
    LDR r0, =whatIsCMsg
    BL printf
    POP {r0, r1, r2, r5}
    PUSH {r0, r1, r2, r5}
    BL calcC
    POP {r0, r1, r2, r5}
    MOV r5, #Len
    PUSH {r0, r1, r2 ,r5}
    BL printC @branch to print array C
    POP {r0, r1, r2, r5}
    POP {lr}
    MOV pc, lr

printA: @print array A
    PUSH {lr} @push lr to stack
    PUSH {r0}
    LDR r0, =printAMsg
    BL printf
    BL printArray
    POP {lr}
    MOV pc, lr

printB: @print array B
    PUSH {lr} @push lr to stack
    PUSH {r1}
    LDR r0, =printBMsg
    BL printf
    BL printArray
    POP {lr}
    MOV pc, lr

printC: @print array C
    PUSH {lr} @push lr to stack
    PUSH {r2}
    LDR r0, =printCMsg
    BL printf
    BL printArray
    POP {lr}
    MOV pc, lr

printArray: @print array
    POP {r1}
    PUSH {lr}
    LDR r0, =printArrayStart
    ADD r11, r1, #4
    PUSH {r11}
    LDR r1, [r11]
    BL printf
    POP {r11}
    PUSH {r11}
    LDR r0, =printArrayMid
    LDR r1, [r11, #4]
    BL printf
    POP {r11}
    PUSH {r11}
    LDR r0, =printArrayMid
    LDR r1, [r11, #8]
    BL printf
    POP {r11}
    PUSH {r11}
    LDR r0, =printArrayMid
    LDR r1, [r11, #12]
    BL printf
    POP {r11}
    PUSH {r11}
    LDR r0, =printArrayMid
    LDR r1, [r11, #16]
    BL printf
    POP {r11}
    PUSH {r11}
    LDR r0, =printArrayMid
    LDR r1, [r11, #20]
    BL printf
    POP {r11}
    PUSH {r11}
    LDR r0, =printArrayMid
    LDR r1, [r11, #24]
    BL printf
    POP {r11}
    PUSH {r11}
    LDR r0, =printArrayMid
    LDR r1, [r11, #28]
    BL printf
    POP {r11}
    PUSH {r11}
    LDR r0, =printArrayMid
    LDR r1, [r11, #32]
    BL printf
    POP {r11}
    LDR r0, =printArrayEnd
    LDR r1, [r11, #36]
    BL printf
    POP {lr}
    MOV pc, lr

calcC: @calc c with for loop for iterating through arrays
    LDR r3, [r0, #4]! @get element of A
    LDR r4, [r1, #4]! @get element of B
    ADD r3, r3, r4 @add two elements
    STR r3, [r2, #4]! @store result in C
    SUBS r5, r5, #1 @test for end of loop
    BNE calcC @repeat until done
    MOV pc, lr

userInput: @get user input for z/p/n
    PUSH {lr} @push lr to stack
    PUSH {r0, r1, r2, r5} @push registers to stack

    LDR r0, =userInputMsg  @message to print
    BL printf @print message
    LDR r0, =numInputPattern @scanf pattern
	LDR r1, =intInput @user input integer
	BL scanf @get user input
	cmp r0, #READERROR @check for readerror
	BEQ intInputError @branch if read error

    LDR r1, =intInput
	LDR r1, [r1]

    CMP r1, #0 @check for valid integer
	BLT intInputError @branch if invalid
	CMP r1, #2 @ check for valid input
	BGT intInputError @branch if invalid

    CMP r1, #0 @compare user input with 1
    BLEQ printZero @print zero chosen
    CMP r1, #2
    BLEQ printNeg @print neg chosen
    CMP r1, #1
    BLEQ printPos @print pos chosen
    POP {lr}
    MOV pc, lr

printZero:  @print zero values
    POP {r0, r1, r2, r5}
    PUSH {lr}
    PUSH {r0, r1, r2, r5}
    LDR r0, =strZeroChosen
    BL printf
    POP {r0, r1, r2, r5}
    BL loopForZero
    LDR r0, =printEndLine
    BL printf
    POP {lr}
    MOV pc, lr

printPos:  @print positive values
    POP {r0, r1, r2, r5}
    PUSH {lr}
    PUSH {r0, r1, r2, r5}
    LDR r0, =strPosChosen
    BL printf
    POP {r0, r1, r2, r5}
    BL loopForPos
    LDR r0, =printEndLine
    BL printf
    POP {lr}
    MOV pc, lr

printNeg:  @print negative values
    POP {r0, r1, r2, r5}
    PUSH {lr}
    PUSH {r0, r1, r2, r5}
    LDR r0, =strNegChosen
    BL printf
    POP {r0, r1, r2, r5}
    BL loopForNeg
    LDR r0, =printEndLine
    BL printf
    POP {lr}
    MOV pc, lr

printValue:  @print a single value stored in r3
    MOV r1, r3 @load r1 with register 3
    LDR r0, =printVal
    PUSH {lr}
    BL printf
    POP {lr}
    MOV pc, lr

loopForZero: @loop over C and print zeros
    PUSH {lr}
    LDR r3, [r2, #4]! @get element of C
    PUSH {r2}
    CMP r3, #0
    BLEQ printValue
    POP {r2}
    POP {lr}
    SUBS r5, r5, #1 @test for end of loop
    BNE loopForZero @repeat until done
    MOV pc, lr

loopForPos: @loop over C and print positives
    PUSH {lr}
    LDR r3, [r2, #4]! @get element of C
    PUSH {r2, r5}
    CMP r3, #0
    BLGT printValue
    POP {r2, r5}
    POP {lr}
    SUBS r5, r5, #1 @test for end of loop
    BNE loopForPos @repeat until done
    MOV pc, lr

loopForNeg: @loop over C and print negatives
    PUSH {lr}
    LDR r3, [r2, #4]! @get element of C
    PUSH {r2, r5}
    CMP r3, #0
    BLLT printValue
    POP {r2, r5}
    POP {lr}
    SUBS r5, r5, #1 @test for end of loop
    BNE loopForNeg @repeat until done
    MOV pc, lr

intInputError: @ input read error for z/p/n input
	LDR r0, =strErrorInput @error message
	BL printf @print error message
	LDR r0, =strInputPattern
	LDR r1, =strInputError
	BL scanf @ clear scan
    POP {r0, r1, r2, r5} @pop registers back
	POP {lr} @pop lr
	SUB lr, lr, #4 @revert lr to retry user input
	MOV pc, lr

exit: @ exit the program
	MOV r7, #0x01
	SVC 0

.data
.balign 4
strInputPattern: .asciz "%[^\n]"

.balign 4
strWelcomePrompt: .asciz "Thank you for using a auto indexer. The program will add elements of arrays A and B to create array C. Then you can enter (0:zero, 1:positive, 2:negative) to print all elements of array C that are either zero, positive or negative.\n\n"

.balign 4
printAMsg: .asciz "Printing Array A :\n"

.balign 4
printBMsg: .asciz "Printing Array B :\n"

.balign 4
printCMsg: .asciz "Printing Array C :\n"

.balign 4
whatIsCMsg: .asciz "Array C = Array A + Array B\n"

.balign 4
printArrayStart: .asciz "[%d"

.balign 4
printArrayMid: .asciz ", %d"

.balign 4
printArrayEnd: .asciz ", %d]\n"

.balign 4
numInputPattern: .asciz "%d"

.balign 4
intInput:	 .word 0

.balign 4
userInputMsg: .asciz "Enter integer (0:zero, 1:positive, 2:negative) for which elements of array C to print: "

.balign 4
strErrorInput:  .asciz "Error. Invalid integer entered for which elements of array C to print. Must be 0 for zero values, 1 for positive values or 2 for negative values. Please try again.\n"

.balign 4
strInputError:	 .skip 100*4

.balign 4
strZeroChosen:    .asciz "Printing Zero values: \n"

.balign 4
strPosChosen:    .asciz "Printing Pos values: \n"

.balign 4
strNegChosen:    .asciz "Printing Neg values: \n"

.balign 4
printVal:   .asciz "%d "

.balign 4
printEndLine:   .asciz "\n"

A:  .word 24, -1, 61, -95, 5, 59, -23, -12, 259, 614
B:  .word 10, 32, -763, 2351, 87, -24, 0, 12, 259, 614
C:  .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.global printf
.global scanf
