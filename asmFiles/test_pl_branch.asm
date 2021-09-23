# Pipeline Unit Test for Branch
  org 0x0000	
  ori $a0, $0, 0x5
  ori $a1, $0, 0x4
  bne $a0, $a1, TAKEN
NOT_TAKEN:
  push $a0
TAKEN:
  addi $a1, $a1, 0x4
  push $a1
  halt
