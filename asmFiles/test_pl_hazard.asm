# Pipeline Unit Test for RAW Hazard
  org   0x0000
  addi  $sp, $0, 0xFFFC
  ori   $s1, $0, 0x0100
  ori   $s0, $0, 0x6
  sw    $s0, 0($s1)
  addi  $v0, $0, 0x2
  lw    $v0, 0($s1)
  addi  $v0, $v0, 0x3
  push  $v0
  halt
