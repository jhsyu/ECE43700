org 0x0

J_TEST: 
    addi    $v0, $zero, 1
    j		JAL_TEST				
    addi    $v0, $zero, -1
    halt
JAL_TEST:
    addi	$v1, $zero, 1	
    jal		JR_TEST
    sw		$v0, 0xF0($zero)
    sw		$v1, 0xF4($zero)
    halt

		
JR_TEST: 
    jr		$ra					
    addi	$v1, $zero, -1	
    halt
    

    

 
