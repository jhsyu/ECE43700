org 0x0

    addi	$t0, $zero, 0
    beq		$t0, $zero, BEQ_TEST0   # taken
    addi    $s0, $zero, -1 	
    halt

BEQ_TEST0: 
    addi    $s0, $zero, 1
    addi    $t0, $zero, 1

    beq     $t0, $zero, BEQ_TEST1   # not taken
    addi    $s1, $zero, 1

    bne		$t0, $zero, BNE_TEST0 	# taken
    addi    $s2, $zero, -1
    halt

BNE_TEST0: 
    addi	$s2, $zero, 1			# $v1 = $zero + 1
    addi    $t0, $zero, 0
    bne     $t0, $zero, BNE_TEST1   # not taken
    addi    $s3, $zero, 1
    

    addi	$t1, $zero, 0xF0			# $t1 = $zero + 0xFF
    sw		$s0, 0($t1)
    sw		$s1, 4($t1)
    sw		$s2, 8($t1)
    sw		$s3, 12($t1)
    halt

BEQ_TEST1:
    addi	$s1, $zero, -1		# $s1 = $zero + -1
    halt

BNE_TEST1: 
    addi    $s3, $zero, -1
    halt

