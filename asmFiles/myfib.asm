org 0x0
MAIN: 
    ori     $a0, $zero, 6       # driver function. 
    jal     FIB0                # will not be counted. 
EXIT: 
    halt

FIB0: 
    addi    $v0, $zero, 0       # set $v0 as 0, and return 
    beq     $a0, $zero, RTN     # if n == 0. 
FIB1: 
    addi    $v0, $zero, 1       # set $v0 as 1, and return. 
    beq     $a0, $v0, RTN       # if n == 1. 
FIBN: 
    push    $ra                 # use stack to store return addr
    push    $a0                 # and n in $a0. 
    addi    $a0, $a0, -1        
    jal     FIB0                # call $v0 = fib(n-1)
    pop     $a0                 # restore n in $a0. 
    push    $v0                 # store $v0 = fib(n-1)
    addi    $a0, $a0, -2        
    jal     FIB0                # call fib(n-2)
    pop     $t0                 # $t0 = fib(n-1)
    add     $v0, $v0, $t0       # fib(n-1) + fib(n-2)
    pop     $ra
RTN: 
    jr      $ra
