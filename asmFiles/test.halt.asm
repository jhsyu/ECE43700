org 0x0
addi	$v0, $zero, 1			# $v0 = $zero + 1
sw		$v0, 0xF0($zero)		# 

halt
addi	$v0, $zero, -1			# $t0 = $t1 + 0
sw		$v0, 0xF0($zero)		# 

