@ File: studentInput.s
@ Author: Paul Abers
@ Assignment: Lab 5


OUTPUT = 1
INPUT  = 0

PUD_UP = 2
PUD_DOWN = 1

LOW = 0
HIGH = 1

ZERO = 0
ONE = 1
MAXCOUNT = 10

.text
.balign 4
.global main

main:

welcome: @welcome message for user
    LDR r0, =strWelcomePrompt1
    BL printf
    LDR r0, =strWelcomePrompt2
    BL printf
    LDR r0, =strWelcomePrompt3
    MOV r1, #MAXCOUNT
    BL printf

setup:  @check GPIO for proper setup
    BL setupCounts
    BL wiringPiSetup
    MOV r1,#-1
    CMP r0, r1
    BNE setButtonToInput
    B failureExit

setupCounts:    @setup counts for buttons
    MOV r12, #ZERO @total count
    MOV r4, #ZERO @blue count
    MOV r5, #ZERO @green count
    MOV r6, #ZERO @yellow count
    MOV r7, #ZERO @red count
    PUSH {r12}
    MOV pc, lr

setButtonToInput:   @setup inputs to button
    LDR r0, =buttonBlue
    LDR r0, [r0]
    MOV r1, #INPUT
    BL pinMode

    LDR r0, =buttonGreen
    LDR r0, [r0]
    MOV r1, #INPUT
    BL pinMode

    LDR r0, =buttonYellow
    LDR r0, [r0]
    MOV r1, #INPUT
    BL pinMode

    LDR r0, =buttonRed
    LDR r0, [r0]
    MOV r1, #INPUT
    BL pinMode

setupButtons: @setup and read all buttons
    LDR r0, =buttonBlue
    LDR r0, [r0]
    MOV r1, #PUD_UP
    BL pullUpDnControl

    LDR r0, =buttonGreen
    LDR r0, [r0]
    MOV r1, #PUD_UP
    BL pullUpDnControl

    LDR r0, =buttonYellow
    LDR r0, [r0]
    MOV r1, #PUD_UP
    BL pullUpDnControl

    LDR r0, =buttonRed
    LDR r0, [r0]
    MOV r1, #PUD_UP
    BL pullUpDnControl

    MOV r8, #0xff
    MOV r9, #0xff
    MOV r10, #0xff
    MOV r11, #0xff

ButtonLoop: @loop for button pressing
    POP {r12}
    PUSH {r12}
    CMP r12, #MAXCOUNT
    BEQ finished
    LDR r0, =delayMs
    LDR r0, [r0]
    BL delay

readBlue:   @ read value of blue button
    LDR r0, =buttonBlue
    LDR r0, [r0]
    BL digitalRead
    CMP r0, #HIGH
    MOVEQ r9, r0
    BEQ readGreen
    CMP r9, #LOW
    BEQ readGreen
    MOV r9, r0
    B PedBLUE

readGreen:   @ read value of blue button
    LDR r0, =buttonGreen
    LDR r0, [r0]
    BL digitalRead
    CMP r0, #HIGH
    MOVEQ r10, r0
    BEQ readYellow
    CMP r10, #LOW
    BEQ readYellow
    MOV r10, r0
    B PedGREEN

readYellow:   @ read value of blue button
    LDR r0, =buttonYellow
    LDR r0, [r0]
    BL digitalRead
    CMP r0, #HIGH
    MOVEQ r11, r0
    BEQ readRed
    CMP r11, #LOW
    BEQ readRed
    MOV r11, r0
    B PedYELLOW

readRed:   @ read value of blue button
    LDR r0, =buttonRed
    LDR r0, [r0]
    BL digitalRead
    CMP r0, #HIGH
    MOVEQ r8, r0
    BEQ ButtonLoop
    CMP r8, #LOW
    BEQ ButtonLoop
    MOV r8, r0
    B PedRED

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Print out which button was pressed.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

PedBLUE:
    LDR  r0, =PressedBLUE @ Put address of string in r0
    BL   printf           @ Make the call to printf
    POP {r12}
    ADD r4, #1
    ADD r12, #1
    PUSH {r12}
    B    ButtonLoop       @ Go read more buttons

PedGREEN:
    LDR  r0, =PressedGREEN @ Put address of string in r0
    BL   printf            @ Make the call to printf
    POP {r12}
    ADD r5, #1
    ADD r12, #1
    PUSH {r12}
    B    ButtonLoop        @ Go read more buttons

PedYELLOW:
    LDR  r0, =PressedYELLOW @ Put address of string in r0
    BL   printf             @ Make the call to printf
    POP {r12}
    ADD r6, #1
    ADD r12, #1
    PUSH {r12}
    B    ButtonLoop         @ Go read more buttons

PedRED:
    LDR  r0, =PressedRED  @ Put address of string in r0
    BL   printf           @ Make the call to printf
    POP {r12}
    ADD r7, #1
    ADD r12, #1
    PUSH {r12}
    B    ButtonLoop       @ Go read more buttons

finished:   @looping finished, print button presses
    LDR r0, =strButtonLimit
    MOV r1, #MAXCOUNT
    BL printf
    LDR r0, =strBlueCount
    MOV r1, r4
    BL printf
    LDR r0, =strGreenCount
    MOV r1, r5
    BL printf
    LDR r0, =strYellowCount
    MOV r1, r6
    BL printf
    LDR r0, =strRedCount
    MOV r1, r7
    BL printf
    B successExit

successExit:    @code succeeded, exit gracefully
    LDR r0, =strSuccessExit
    BL printf
    B exit

failureExit:    @setup failed, exit ungracefully
    LDR r0, =strFailExit
    BL printf
    B exit

exit: @exit code
    MOV r0, r8
    MOV r7, #0x01
    SVC 0

.data
.balign 4

buttonBlue:   .word 7 @Blue button
buttonGreen:  .word 0 @Green button
buttonYellow: .word 6 @Yellow button
buttonRed:    .word 1 @Red button

delayMs: .word 250  @ Delay time in Miliseconds.

.balign 4
strWelcomePrompt1:    .asciz "Lab 5 Raspberry Pi Buttons with Assembly.\n"

.balign 4
strWelcomePrompt2:    .asciz "Press any of the buttons (Blue, Green, Yellow, or Red).\n"

.balign 4
strWelcomePrompt3:    .asciz "Program will count the number of times each button is pressed. Once the total count reaches %d, the program will print the count of each button and then exit.\n\nBegin:\n\n"

.balign 4
strCurrentCount:    .asciz "Current count is %d\n"

.balign 4
PressedBLUE: .asciz "The BLUE button was pressed. \n"

.balign 4
PressedYELLOW: .asciz "The YELLOW button was pressed.\n"

.balign 4
PressedGREEN: .asciz "The GREEN button was pressed. \n"

.balign 4
PressedRED:  .asciz "The RED button was pressed. \n"

.balign 4
strButtonLimit:    .asciz "\nMax button limit of %d was reached.\n\n"

.balign 4
strBlueCount:    .asciz "The blue button was pressed %d times.\n"

.balign 4
strGreenCount:    .asciz "The green button was pressed %d times.\n"

.balign 4
strYellowCount:    .asciz "The yellow button was pressed %d times.\n"

.balign 4
strRedCount:    .asciz "The red button was pressed %d times.\n"

.balign 4
strSuccessExit:    .asciz "\nCode succeeded. Exiting gracefully...\n"

.balign 4
strFailExit:    .asciz "\nSetup of GPIO failed. Aborting...\n"

.global printf

.extern wiringPiSetup
.extern delay
.extern digitalWrite
.extern pinMode

@end of code
