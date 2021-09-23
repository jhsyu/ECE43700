# Pipeline Unit Test for RAW Hazard
  org   0x0000
  addi  $sp, $0, 0xFFFC
  ori   $s0, $0, 0x6
  ori   $s1, $0, 0x3
  add   $s2, $s0, $s1  # s2 <= 0x6 + 0x3 = 0x9
  add   $s3, $s2, $s1  # s3 <= 0x9 + 0x3 = 0xC
  add   $s4, $s2, $s0  # s4 <= 0x9 + 0x6 = 0xF
  push  $s4
  halt
