#------------------------------------------
# Originally Test and Set example by Eric Villasenor
# Modified to be LL and SC example by Yue Du
#------------------------------------------

#----------------------------------------------------------
# First Processor
#----------------------------------------------------------
  org   0x0000              # first processor p0
  ori   $sp, $zero, 0x3ffc  # stack
  lui   $s0, 0x1234         # load upper 16 bits of seed
  ori   $s0, $s0, 0x1234    # load lower 16 bits of seed
  ori   $s1, $zero, 0x0
  jal   mainp0              # go to program
  halt

#-max (a0=a,a1=b) returns v0=max(a,b)----------------------
max:
  #push  $ra
  #push  $a0
  #push  $a1
  addiu $sp, $sp, -4
  sw    $ra, 0($sp)
  addiu $sp, $sp, -4
  sw    $a0, 0($sp)
  addiu $sp, $sp, -4
  sw    $a1, 0($sp)
	
  or    $v0, $0, $a0
  slt   $t0, $a0, $a1
  beq   $t0, $0, maxrtn
  or    $v0, $0, $a1
maxrtn:
  #pop   $a1
  #pop   $a0
  #pop   $ra
  lw    $a1, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4
  lw    $a0, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4
  lw    $ra, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4

  jr    $ra
#--------------------------------------------------

#-min (a0=a,a1=b) returns v0=min(a,b)--------------
min:
  #push  $ra
  #push  $a0
  #push  $a1
  addiu $sp, $sp, -4
  sw    $ra, 0($sp)
  addiu $sp, $sp, -4
  sw    $a0, 0($sp)
  addiu $sp, $sp, -4
  sw    $a1, 0($sp)

  or    $v0, $0, $a0
  slt   $t0, $a1, $a0
  beq   $t0, $0, minrtn
  or    $v0, $0, $a1
minrtn:
  #pop   $a1
  #pop   $a0
  #pop   $ra
  lw    $a1, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4
  lw    $a0, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4
  lw    $ra, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4

  jr    $ra
#----------------------------------------------------------

	
#----------------------------------------------------------
# $v0 = crc32($a0)
crc32:
  lui $t1, 0x04C1
  ori $t1, $t1, 0x1DB7
  or $t2, $0, $0
  ori $t3, $0, 32

ls1:
  slt $t4, $t2, $t3
  beq $t4, $zero, ls2

  ori $t5, $0, 31
  srlv $t4, $t5, $a0
  ori $t5, $0, 1
  sllv $a0, $t5, $a0
  beq $t4, $0, ls3
  xor $a0, $a0, $t1
ls3:
  addiu $t2, $t2, 1
  j ls1
ls2:
  or $v0, $a0, $0
  jr $ra
#----------------------------------------------------------

	
#----------------------------------------------------------
# pass in an address to lock function in argument register 0
# returns when lock is available
lock:
aquire:
  ll    $t0, 0($a0)         # load lock location
  bne   $t0, $0, aquire     # wait on lock to be open
  addiu $t0, $t0, 1
  sc    $t0, 0($a0)
  nop
  beq   $t0, $0, lock       # if sc failed retry
  jr    $ra
#----------------------------------------------------------


#----------------------------------------------------------
# pass in an address to unlock function in argument register 0
# returns when lock is free
unlock:
  sw    $0, 0($a0)
  jr    $ra
#----------------------------------------------------------


# PRODUCER (PROCESSOR 0)
mainp0:
  #push  $ra
  addiu $sp, $sp, -4
  sw    $ra, 0($sp)

  ori   $a0, $zero, l1      # move lock to arguement register
  jal   lock                # try to aquire the lock
  # critical code segment
  ori   $t5, $zero, 2       # left shift to multiply by 4
  ori   $t2, $zero, buff_occ
  ori   $t3, $zero, buffer
  lw    $t0, 0($t2)         # load buffer occupancy value
  addiu $t4, $t0, 1         # increment buffer occupancy
  sllv  $t1, $t5, $t0       # shift buff_occ left by 2
  ori   $t5, $zero, 2     # temp variable holds max buffer size
  beq   $s1, $t5, EXIT0     # if loop has run 256 times, exit loop
  beq   $t0, $t5, EXIT0     # if buff_occ == 256, exit loop (redundant but safer)
  addu  $t1, $t1, $t3       # new buffer index address pointer
  #push  $t1
  #push  $t2
  #push  $t4
  addiu $sp, $sp, -4
  sw    $t1, 0($sp)
  addiu $sp, $sp, -4
  sw    $t2, 0($sp)
  addiu $sp, $sp, -4
  sw    $t4, 0($sp)

  add   $a0, $zero, $s0     # move seed value to argument
  jal   crc32               # generate seed value
  addiu $s1, $s1, 1         # increment loop counter

  #pop   $t4
  #pop   $t2
  #pop   $t1
  lw    $t4, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4
  lw    $t2, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4
  lw    $t1, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4

  add   $s0, $zero, $v0     # move new random number to saved register
  add   $t5, $zero, $v0     # move new random number to store register

	
  sw    $t4, 0($t2)         # store new buffer occupancy value
  sw    $t5, 0($t1)         # store random number onto the shared stack
  # unlock and stay in loop
  ori   $a0, $zero, l1      # move lock to arguement register
  jal   unlock              # release the lock
  #pop   $ra
  lw    $ra, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4

  j mainp0
  # critical code segment
EXIT0:
  ori   $a0, $zero, l1      # move lock to arguement register
  jal   unlock              # release the lock
  #pop   $ra
  lw    $ra, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4

  jr    $ra                 # return to caller
l1:
  cfw 0x0


#----------------------------------------------------------
# Second Processor
#----------------------------------------------------------
  org   0x200               # second processor p1
  ori   $sp, $zero, 0x7ffc  # stack
  ori   $s1, $zero, 0x0
  jal   mainp1              # go to program
  halt

# CONSUMER (PROCESSOR 1)
mainp1:
  #push  $ra
  addiu $sp, $sp, -4
  sw    $ra, 0($sp)

  ori   $a0, $zero, l1      # move lock to arguement register
  jal   lock                # try to aquire the lock
  # critical code segment
  ori   $t5, $zero, 2     # set max loop counter
  beq   $s1, $t5, EXIT1     # if loop count is 256, leave loop
  ori   $t5, $zero, 2       # temp register for shifting left by 2
  ori   $t2, $zero, buff_occ
  ori   $t3, $zero, buffer
  lw    $t0, 0($t2)
  addi  $t4, $t0, -1
  sllv  $t1, $t5, $t4       # shift buff_occ left to multiply by 4
  bne   $t0, $zero, CNSME   # if buff_occ == 0, unlock and try again
  # unlock and stay in loop
  ori   $a0, $zero, l1      # move lock to arguement register
  jal   unlock              # release the lock
  #pop   $ra   
  lw    $ra, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4

  j mainp1
CNSME:
  addu  $t1, $t1, $t3       # new buffer index pointer
  lw    $t3, 0($t1)
  andi  $t3, $t3, 0xFFFF
  #push  $t1
  #push  $t2
  #push  $t4
  addiu $sp, $sp, -4
  sw    $t1, 0($sp)
  addiu $sp, $sp, -4
  sw    $t2, 0($sp)
  addiu $sp, $sp, -4
  sw    $t4, 0($sp)

  ori   $a0, $t3, 0x0
  bne   $s1, $zero, USE_MAX
  ori   $s4, $zero, 0x0
  ori   $a1, $t3, 0x0
  j     MIN_MAX2
USE_MAX:
  ori   $a1, $s2, 0x0
MIN_MAX2:
  add   $s4, $s4, $t3
  andi  $a0, $a0, 0xFFFF
  andi  $a1, $a1, 0xFFFF
  jal   max
  ori   $s2, $v0, 0x0

  ori   $a0, $t3, 0x0
  bne   $s1, $zero, USE_MIN
  ori   $a1, $t3, 0x0
  j     MIN_MAX1
USE_MIN:
  ori   $a1, $s3, 0x0
MIN_MAX1:
  andi  $a0, $a0, 0xFFFF
  andi  $a1, $a1, 0xFFFF
  jal   min
  ori   $s3, $v0, 0x0

  #pop   $t4
  #pop   $t2
  #pop   $t1
  lw    $t4, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4
  lw    $t2, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4
  lw    $t1, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4

  sw    $t4, 0($t2)         # store new buffer occupancy value
  sw    $zero, 0($t1)       # remove random number from the stack
  addiu $s1, $s1, 1

  # unlock and stay in loop
  ori   $a0, $zero, l1      # move lock to arguement register
  jal   unlock              # release the lock
  #pop   $ra
  lw    $ra, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4
  j mainp1

  # critical code segment
EXIT1:
  ori   $t5, $zero, 0x8
  srlv  $s4, $t5, $s4
  ori   $a0, $zero, l1      # move lock to arguement register
  jal   unlock              # release the lock
  ori   $t2, $zero, MAX_LOC
  sw    $s2, 0($t2)         # store max value at MAX_LOC
  ori   $t2, $zero, MIN_LOC
  sw    $s3, 0($t2)         # store min value at MIN_LOC
  ori   $t2, $zero, AVG_LOC
  sw    $s4, 0($t2)         # store avg value at AVG_LOC

  #pop   $ra
  lw    $ra, 0($sp)
  sw    $zero, 0($sp)
  addiu $sp, $sp, 4
  jr    $ra                 # return to caller

MAX_LOC:
  cfw 0x0
	
MIN_LOC:
  cfw 0x0

AVG_LOC:
  cfw 0x0

buff_occ:
  cfw 0x0                   # buffer occupancy value

buffer:
  cfw 0x0
