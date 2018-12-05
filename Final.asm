.EQU INPUT_STEP = 0x30 ; 7 bit input
.EQU INPUT_DIR = 0x31
.EQU STEPPER1 = 0x40 ; Left/Right
.EQU STEPPER2 = 0x41 ; Up/Down

.CSEG
.ORG 0x01

INIT:	IN R0, INPUT_STEP ; Stores amount of steps
		IN R1, INPUT_DIR ; Determines left/right/up/down

REMOVE_MSB:	MOV R2, R0 ; Copy STEP to new register for manipulation
			CMP R2, 0x80 ; Check if greater than 128 to remove 8th bit if necessary
			BRCC SUBTRACT

CHECK_DIR: 	CMP R1, 0x00	; Based on direction, goes to proper output subroutine
			BREQ RIGHT
			CMP R1, 0x01
			BREQ LEFT
			CMP R1, 0x02
			BREQ UP
			CMP R1, 0x03
			BREQ DOWN
			BRN END			; If direction input is not left/right/up/down, nothing is outputted

SUBTRACT:	SUB R2, 0x80
			BRN CHECK_DIR

; Direction 0 on STEPPER1 -> DIR is 0
RIGHT:	OUT R2, STEPPER1
		BRN END

; Direction 1 on STEPPER1 -> DIR is 1
LEFT:	ADD R2, 0x80
		OUT R2, STEPPER1
		BRN END

; Direction 0 on STEPPER2 -> DIR is 2
UP:		OUT R2, STEPPER2
		BRN END

; Direction 1 on STEPPER2 -> DIR is 3
DOWN:	ADD R2, 0x80
		OUT R2, STEPPER2
		BRN END

END: 
