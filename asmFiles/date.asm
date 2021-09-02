# Jiahao Xu, Fall 2021

# main program placed at 0x0. 
org     0x0

MAIN: 
    ori     $s0, $zero, 2021    # year
    ori     $s1, $zero, 1       # month
    ori     $s2, $zero, 1       # day

    ori     $t0, $zero, 365
    push    $t0
    addi    $t1, $s0, -2000
    push    $t1
    jal     MULT
    pop     $s3                 # (year-2000)*365

    ori     $t0, $zero, 30
    push    $t0
    addi    $t1, $s1, -1
    push    $t1
    jal     MULT
    pop     $s4                 # 30 * (month - 1)
    add     $v0, $s3, $s4
    add     $v0, $v0, $s2
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

