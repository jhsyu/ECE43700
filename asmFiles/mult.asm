# Jiahao Xu, Fall 2021

# main program: placed at 0x0
org 0x0
MAIN: 
    ori $sp, $zero, 0xFFFC      # initialize the stack pointer. 
    ori $a0, $zero, 1
    ori $a1, $zero, 3           # place the oprands in the argument register. 
    push $a0
    push $a1                    # push the oprands into stack. 
    jal		MULT				# jump to MULT and save position to $ra
EXIT: 
    pop     $v0
    halt
MULT:
    ori     $t0, $zero, 0x0     # initial the index at $t0. 
    ori     $v0, $zero, 0x0     # initial the result as 0. 
    pop     $t1                 # pop the oprands. 
    pop     $t2
MULT_IF: 
    beq		$t0, $t1, MULT_END 	# if $v0 is 0, skip the mult. 
    addi    $t0, $t0, 1
    add     $v0, $v0, $t2       # add $t2 to $v0 (result). 
    j		MULT_IF				# jump to MULT_IF 
MULT_END: 
    push    $v0                 # push the result to the stack. 
    jr		$ra					# return

    
