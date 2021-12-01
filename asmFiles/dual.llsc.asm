#------------------------------------------------------------------
# Test llsc1
# Note: SW/SC should invalidate the link register if there is an
#       address match in the opposite core or in the same core.
#------------------------------------------------------------------

  org   0x0000
  ori   $1, $zero, 0x1FC0
  ori   $2, $zero, 0x80

  lw    $3, 0($2) # $3 -> 0
  addiu   $3, $3, 0x01 # $3 -> 1
  sw    $3, 0($2) # mem[0x80] -> 1

  ll    $3, 0($2) # link: 0x80
  addiu   $3, $3, 0x01 # $3 -> 2
  sc    $3, 0($2) # link: inv, mem[0x80] -> 2
  sc    $3, 0($2) # link: inv,  $3 <- 0

  ll    $3, 8($2) #link : 0x88, $3 -> 0
  addiu   $3, $3, 0x01 # $3 -> 1
  sw    $3, 8($2) # link: inv, mem[0x80] -> 1
  sc    $3, 8($2) # $3 -> 0 
  sw    $3, 8($2) # mem[0x88] -> 0 
  

  halt      # that's all

  org   0x0200
  ori   $1, $zero, 0x1FC0
  ori   $2, $zero, 0x90

  lw    $3, 0($2)
  addiu   $3, $3, 0x01
  sw    $3, 0($2)

  ll    $3, 0($2)
  addiu   $3, $3, 0x01
  sc    $3, 0($2)
  sc    $3, 0($2)

  ll    $3, 8($2)
  addiu   $3, $3, 0x01
  sw    $3, 8($2)
  sc    $3, 8($2)
  sw    $3, 8($2)

  halt      # that's all


