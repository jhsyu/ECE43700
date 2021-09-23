# Pipeline Unit Test for Basic Addition
  org  0x0000	
  ori  $a0, $0, 0x5
  ori  $a1, $0, 0x4
  add  $v0, $a0, $a1  # $v0 <= 0x9
  halt
