  org 0x0000 # core 0
  addi $t0, $0, 0x1
  addi $t1, $0, 0x2
  addi $t2, $0, 0x3

  sw $t0, 0x160($zero) # invalid to modify
  sw $t1, 0x160($zero) # modify to modify
  lw $t1, 0x170($zero) # invalid to shared
  lw $t1, 0x170($zero) # shared to shared
  nop
  nop
  nop
  nop
  nop
  sw $t2, 0x180($zero) # invalid to modify
  nop
  halt
  
  org 0x160
  cfw 0xABCD
  cfw 0xBEEF

  org 0x170
  cfw 0x1234
  cfw 0x5678

  org 0x180
  cfw 0x1111
  cfw 0x2222

  org 0x0200 # core 1
  addi $t0, $0, 0x1
  addi $t1, $0, 0x2
  addi $t2, $0, 0x3

  nop
  nop
  nop
  nop
  lw $t0, 0x160($zero) # modify to shared
  sw $t0, 0x160($zero) # shared to invalid
  nop
  sw $t1, 0x180($zero) # modify to invalid
  halt
	


