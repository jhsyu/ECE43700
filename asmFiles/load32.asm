org     0x0
ori     $t1, $zero, 16
ori     $v0, $zero, 0x2001
sllv    $v0, $t1, $v0
ori     $v0, $v0, 0x4924
halt
