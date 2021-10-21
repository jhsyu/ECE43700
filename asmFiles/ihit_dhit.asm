  org 0x0000
  addi $sp, $0, 0xFFFC

  addi $s0, $0, 0x7
  addi $a0, $0, 0x0224
  addi $s1, $0, 0xF
  sw   $s0, 0($a0)
LOOP:	
  addi $s0, $s0, 0x1
  lw   $s2, 0($a0)
  bne  $s0, $s1, LOOP
  halt
