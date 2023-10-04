# CMPEN 331, Lab 2_part2

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# switch to the Data segment
	.data
	# global data is defined here

	# Don't forget the backslash-n (newline character)
Homework:
	.asciiz	"CMPEN 331 Homework 2\n"
Name:
	.asciiz	"Justin Ngo\n"
 

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# switch to the Text segment
	.text
	# the program is defined here

	.globl	main
main:
	# Whose program is this?
	la	$a0, Homework
	jal	Print_string
	la	$a0, Name
	jal	Print_string
	
	# register assignments
	#  $s0   i
	#  $s1   j = testcase[i]
	#  $s2   n
	#  $t1   a - set1
	#  $t2   b - set2
	#  $t3   c - set3
	#  $t4   d - set4
	#  $s3 	 110
	#  $s4   1110
	#  $s5   11110
	#  $s6   10
	#  $t8   store the shifted variant of s1
	#  $t0   address of testcase[i]
	#  $a0   argument to Print_integer, Print_string, etc.

	# initialization
	li	$s1, 2			# j = 2
	li	$s2, 3			# n = 3
	li 	$s3, 6			# holds value (110)
	li 	$s4, 14			# holds value (1110)
	li 	$s5, 30			# holds value (11110)
	li 	$s6, 2			# holds value (10)
	
	# for (i = 0; i <= 16; i++)
	li	$s0, 0			# i = 0
	la	$t0, testcase		# address of testcase[i]
	bgt	$s0, 16, bottom
top:
	lw	$s1, 0($t0)		# j = testcase[i]
	# Your part starts here
	
	#make sure variables are reset for every run (probably unecessary but ensures things dont get scrambled)
	li $s2, 0 # s2 = 0
	li $t1, 0 # t1 = 0
	li $t2, 0 # t2 = 0
	li $t3, 0 # t3 = 0
	li $t4, 0 # t4 = 0
	li $t5, 0 # t5 = 0
	li $t6, 0 # t6 = 0
	li $t7, 0 # t7 = 0
	li $t8, 0 # t8 = 0
	li $t9, 0 # t9 = 0
	
	#for characters that can be stored in 1 bit
	bgeu $s1, 0x80, two_bits 
	add $s2, $s2, $s1 #set s2 = s1 
	j out
	
two_bits:
	bgtu $s1, 0x7FF, three_bits # n = 110 a + 10 b
	#logic: copy last 6 bits, put 10 in front of that, copy next 5 bits, put 110 in front, set s2 equal to those combined values
	
	#stuff for b (t2)
	and $t2, $s1, 0x3F	# b = lower 6 bits
	sll $t3, $s6, 6		# shift 2 left 6 bits
	add $t5, $t3, $t2	# b = 10 + b
	
	#stuff for a (t1)
	srl $t1, $s1, 6		# shift s1 right 6, store in t1
	and $t1, $t1, 0x1F	# a = next 5 bits
	sll $t1, $t1, 8		# shift a left 8 bits
	sll $t4, $s3, 13	# shift 6 left 13 bits (match t1 shift)
	add $t6, $t4, $t1	# a = 110 + a
	
	#stuff for n (s2)
	add $s2, $t6, $t5
	
	j out
	
three_bits:
	bgtu $s1, 0xFFFF, four_bits # n = 1110 a + 10 b + 10 c
	#logic: copy last 6 bits, add 10, copy next 6 bits, add 10, copy next 4 bits, add 1110, s2 equals combined values
		
	#stuff for c (t3)
	and $t3, $s1, 0x3F	# c = lowest 6 bits
	sll $t4, $s6, 6		# shift 2 left 6 bits
	add $t5, $t4, $t3	# c' = 10 + c
	
	#stuff for b (t2)
	srl $t9, $s1, 6		# shift s1 right 6, store in t9
	and $t2, $t9, 0x3F	# b = next 6 bits
	sll $t2, $t2, 8		# shift t2 left 8 bits to make space for t3
	sll $t4, $s6, 14	# shift 2 left 14 bits to match t2
	add $t6, $t4, $t2	# b' = 10 + b
	
	#stuff for a (t1)
	srl $t9, $s1, 12	# shift s1 right 6, store in t9
	and $t1, $t9, 0xF	# a = next 4 bits
	sll $t1, $t1, 16	# shift a left 16 to make space for t2
	sll $t7, $s4, 20	# shift 14 left 20 to line up with a
	add $t8, $t7, $t1	# a' = 1110 + a
	
	#stuff for n (s2)
	add $s2, $t6, $t5	# answer = b' + c'
	add $s2, $s2, $t8	# answer = a' + b' + c'
	
	j out

four_bits:
	bgtu $s1, 0x10FFFF, failure # n = 11110 a + 10 b + 10 c + 10 d
	
	#stuff for d (t4)
	and $t4, $s1, 0x3F	# d = lowest 6 bits
	sll $t5, $s6, 6		# shift 2 left 6 bits
	add $t4, $t4, $t5	# d' = 10 + d
	
	#stuff for c (t3)
	srl $t9, $s1, 6		# shift s1 right 6, store in t9
	and $t3, $t9, 0x3F	# c = next 6 bits
	sll $t3, $t3, 8		# shift t3 left 8 bits to make space for t4
	sll $t5, $s6, 14	# shift 2 left 14 bits to match t2
	add $t3, $t3, $t5	# c' = 10 + c
	
	#stuff for b (t2)
	srl $t9, $s1, 12	# shift s1 right 12, store in t9
	and $t2, $t9, 0x3F	# b = next 6 bits
	sll $t2, $t2, 16	# shift t2 left 16 bits to make space for t3
	sll $t5, $s6, 22	# shift 2 left 22 bits to match t2
	add $t2, $t2, $t5	# b' = 10 + b
	
	#stuff for a (t1)
	srl $t9, $s1, 18	# shift s1 right 18, store in t9
	and $t1, $t9, 0x7 	# a = next 3 bits
	sll $t1, $t1, 24	# shift t1 left 24 bits to make space for t2
	sll $t6, $s5, 27	# shift 30 left 27 bits to match t1
	add $t1, $t1, $t6	# a' = 11110 + a
	
	#stuff for n (s2)
	add $t7, $t4, $t3	# t7 = t4 + t3
	add $t8, $t2, $t1	# t8 = t2 + t1
	add $s2, $t8, $t7

	j out

failure:
	li $s2, 0xFFFFFFFF

out:
	#this method is only here to break the loop 
	
	# Your part ends here
	
	# print i, j and n
	move	$a0, $s0	# i
	jal	Print_integer
	la	$a0, sp		# space
	jal	Print_string
	move	$a0, $s1	# j
	jal	Print_hex
	la	$a0, sp		# space
	jal	Print_string
	move	$a0, $s2	# n
	jal	Print_hex
	la	$a0, sp		# space
	jal	Print_string
	move	$a0, $s1	# j
	jal	Print_bin
	la	$a0, sp		# space
	jal	Print_string
	move	$a0, $s2	# n
	jal	Print_bin
	la	$a0, nl		# newline
	jal	Print_string
	
	# for (i = 0; i <= 16; i++)
	addi	$s0, $s0, 1	# i++
	addi	$t0, $t0, 4	# address of testcase[i]
	ble	$s0, 16, top	# i <= 16
bottom:
	
	la	$a0, done	# mark the end of the program
	jal	Print_string
	
	jal	Exit0	# end the program, default return status

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	.data
	# global data is defined here
sp:
	.asciiz	" "	# space
nl:
	.asciiz	"\n"	# newline
done:
	.asciiz	"All done!\n"

testcase:
	# UTF-8 representation is one byte
	.word 0x0000	# nul		# Basic Latin, 0000 - 007F
	.word 0x0024	# $ (dollar sign)
	.word 0x007E	# ~ (tilde)
	.word 0x007F	# del

	# UTF-8 representation is two bytes
	.word 0x0080	# pad		# Latin-1 Supplement, 0080 - 00FF
	.word 0x00A2	# cent sign
	.word 0x0627	# Arabic letter alef
	.word 0x07FF	# unassigned

	# UTF-8 representation is three bytes
	.word 0x0800
	.word 0x20AC	# Euro sign
	.word 0x2233	# anticlockwise contour integral sign
	.word 0xFFFF

	# UTF-8 representation is four bytes
	.word 0x10000
	.word 0x10348	# Hwair, see http://en.wikipedia.org/wiki/Hwair
	.word 0x22E13	# randomly-chosen character
	.word 0x10FFFF

	.word 0x89ABCDEF	# randomly chosen bogus value

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Wrapper functions around some of the system calls
# See P&H COD, Fig. A.9.1, for the complete list.

	.text

	.globl	Print_integer
Print_integer:	# print the integer in register $a0 (decimal)
	li	$v0, 1
	syscall
	jr	$ra

	.globl	Print_string
Print_string:	# print the string whose starting address is in register $a0
	li	$v0, 4
	syscall
	jr	$ra

	.globl	Exit
Exit:		# end the program, no explicit return status
	li	$v0, 10
	syscall
	jr	$ra	# this instruction is never executed

	.globl	Exit0
Exit0:		# end the program, default return status
	li	$a0, 0	# return status 0
	li	$v0, 17
	syscall
	jr	$ra	# this instruction is never executed

	.globl	Exit2
Exit2:		# end the program, with return status from register $a0
	li	$v0, 17
	syscall
	jr	$ra	# this instruction is never executed

# The following syscalls work on MARS, but not on QtSPIM

	.globl	Print_hex
Print_hex:	# print the integer in register $a0 (hexadecimal)
	li	$v0, 34
	syscall
	jr	$ra

	.globl	Print_bin
Print_bin:	# print the integer in register $a0 (binary)
	li	$v0, 35
	syscall
	jr	$ra

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
