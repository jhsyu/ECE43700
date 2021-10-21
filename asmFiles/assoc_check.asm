  org 0x0000
  addi $sp, $0, 0xFFFC

  addi $s0, $0, 0x1234
  addi $s1, $0, 0x0234
  addi $a0, $0, 0x5
  addi $a1, $0, 0x3
  sw   $a0, 0($s0)
  sw   $a1, 0($s1)
  lw   $s2, 0($s0)
  lw   $s3, 0($s1)
  halt
