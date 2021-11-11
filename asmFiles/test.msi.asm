  org 0x0000 # core 0
  addi $s0, $0, 0x160
  addi $s1, $0, 0x170
  addi $s2, $0, 0x180
  addi $t0, $0, 0x1
  addi $t1, $0, 0x2
  addi $t2, $0, 0x3

  sw $t0, 0($s0) # invalid to modify
  sw $t1, 0($s0) # modify to modify
  lw $t1, 0($s1) # invalid to shared
  lw $t1, 0($s1) # shared to shared
  nop
  nop
  sw $t2, 0($s2) # invalid to modify
  nop
  halt

  org 0x160
  cfw 0xABCD
  cfw 0xBEEF

  org 0x0200 # core 1
  addi $s0, $0, 0x160
  addi $s1, $0, 0x170
  addi $s2, $0, 0x180
  addi $t0, $0, 0x1
  addi $t1, $0, 0x2
  addi $t2, $0, 0x3

  nop
  nop
  nop
  nop
  lw $t0, 0($s0) # modify to shared
  sw $t0, 0($s0) # shared to invalid
  nop
  sw $t2, 0($s2) # modify to invalid
  halt
	
