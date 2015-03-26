# Fibo recursively computes and returns the Fibonacci number corresponding to a given index.
# Fibo.s

	.data				# variable declarations follow this line
n:	.word	7			# index 
e:	.asciiz	"Error: negative n"	# error message

	.text				# instructions follow this line
main:
	lw	$a0, n			# store n in $a0
	blt	$a0, $zero, error	# exit if n < 0
	jal	fibo			# call fib
	
	add 	$a0, $v0, $zero		# move result to $a0 for syscall
	li 	$v0, 1			# print result to console
	syscall
	li 	$v0, 10			# exit
	syscall
error:	
	la 	$a0, e			# move error message to $a0 for syscall
	li 	$v0, 4			# print error
	syscall
	li 	$v0, 10			# exit
	syscall

fibo:
	addi	$sp, $sp, -12		# create space for storing return address, $s0, $s1
	sw	$ra, 0($sp)		# store return address
	sw	$s0, 4($sp)		# store $s0
	sw	$s1, 8($sp)		# store $s1

	add	$s0, $a0, $zero		# move n to $s0
	addi	$t0, $zero, 2		# store 1 in $t1
	blt	$s0, $t0, ret		# if n < 2, return
	addi	$a0, $s0, -1		# n - 1
	jal	fibo			# get fib(n - 1)
	add	$s1, $zero, $v0		# move fib(n - 1) to $s1
	addi	$a0, $s0, -2		# store n - 2 in $a0
	jal	fibo			# get fib(n - 2)
	add	$s0, $v0, $s1		# fib(n - 2) + fib(n - 1)
ret:
	add	$v0, $s0, $zero
	lw	$ra, 0($sp)		# load words at locations to registers
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	addi	$sp, $sp, 12		# restore stack pointer
	jr	$ra			# return
