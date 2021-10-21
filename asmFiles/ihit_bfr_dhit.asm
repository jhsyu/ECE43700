  org 0x0000
  addi $sp, $0, 0xFFFC

  addi $s0, $0, 0x7
  addi $a0, $0, 0x0224
  addi $s1, $0, 0x9
LOOP:	
  addi $s0, $s0, 0x1
  sw   $s0, 0($a0)
  addi $a0, $a0, 0x8
  bne  $s0, $s1, LOOP
  addi $a1, $0, 0x0224
  lw   $s1, 8($a1)
  halt
