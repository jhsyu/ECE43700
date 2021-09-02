# Jiahao Xu, Fall 2021

# main program placed at 0x0. 
org     0x0
MAIN: 
    ori     $sp, $zero, 0xFFFC
    ori     $t0, $zero, 4
    ori     $t1, $zero, 3
    ori     $t2, $zero, 2
    ori     $t3, $zero, 1
    push    $t3
    or      $s0, $zero, $sp     # 1 oprand in stack. 
    push    $t2
    push    $t1
    push    $t0
MAIN_IF0: 
    beq     $sp, $s0, MAIN_END  # only 1 oprand in stack. 
    jal     MULT
    j       MAIN_IF0
MAIN_END: 
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

