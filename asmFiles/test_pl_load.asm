# Pipeline Unit Test for Load Hazard
  org   0x0000
  addi  $sp, $0, 0xFFFC
  ori   $a0, $0, 0xF0
  ori   $a1, $0, 0x8
  addi  $s0, $a1, 0x5   # s0 <= 0xD
  sw    $a1, 0($a0)
  addi  $s1, $s0, 0x6   # s1 <= 0x13
  lw    $s2, 0($a0)     # s2 <= 0x8
  add   $s3, $s2, $s1   # s3 <= 0x1B
  push  $s3
  halt
