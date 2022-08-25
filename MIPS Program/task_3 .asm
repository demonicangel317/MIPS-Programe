#TAsk 3: The aim of this task is to define and call functions in MIPS
#Input:
#Array length: 3
#Enter the value of n: 2
#Enter num: 1
#Enter num: 2
#Enter num: 4
#Output:
#The number of multiples of 2 is: 1

.globl get_multiples
.data
dataSeg1: .asciiz "The number of multiples of "
dataSeg2: .asciiz " is: "
new_line: .asciiz "\n"

.text
main:   #set fp and make space for locals
	add $fp, $sp, $0 #move $sp into $fp
	addi $sp, $sp, -8 #allocate 5 bytes for array and n 
	
	#initialize locals
	#my_list = [2, 4, 6]
	
	addi $v0, $0, 9		#enter code to allocate memory
	addi $a0, $0, 16	#add the amount of bytes to allocate
	syscall
	sw $v0, -8($fp)		#-8($fp) = pointer to the list	
	addi $t0, $0, 3		#$t0 = 5
	sw $t0, ($v0)		#my_list.length = 3
	
	lw $t0, -8($fp)		#$t0 = pointer to my_list
	addi $t1, $0, 2
	sw $t1, 4($t0) 		#my_list[0] = 2
	addi $t1, $0, 4
	sw $t1, 8($t0) 		#my_list[1] = 4
	addi $t1, $0, 6
	sw $t1, 12($t0) 	#my_list[2] = 6	

	#n = 3
	addi $t0, $0, 3
	sw $t0, -4($fp) 	#n = 3
	
	#get_multiples(my_list, n)))
	#now i will prepre to call the function
	#allocate space for function arguments
	addi $sp, $sp, -8
	
	# arg1 = pointer to my_list
	lw $t0, -8($fp)
	sw $t0, 0($sp)		#arg1 = my_list pointer
	
	# arg2 = n
	lw $t0, -4($fp)
	sw $t0, 4($sp)		#arg2 = n
	
	#link and go to get_multiples
	jal get_multiples	#getting back the return values(caller)
	addi $sp, $sp, 8 	#deallocating arg1 and arg2	
	add $t0, $0, $v0 	#$t0 = returned count
	
	#printing string 1
	addi $v0, $0, 4		#adding code to print a string
	la $a0, dataSeg1	#placing string in $a0
	syscall
	
	#printing n	
	addi $v0, $0, 1		
	lw $t1,-4($fp)		#adding code to print an int
	add $a0, $0, $t1	#placing int in $a0
	syscall
	
	#pring string 2
	addi $v0, $0, 4		#adding code to print a string
	la $a0, dataSeg2	#placing string in $a0
	syscall
	
	#printing the result
	addi $v0, $0, 1		#adding code to print an int
	add $a0, $0, $t0	#placing string in $a0
	syscall

	#printing new line
	addi $v0, $0, 4		#adding code to print a string
	la $a0, new_line	#add new line in $a0
	syscall
	
	# remove locals, then exit
	addi $sp, $sp, 20
	addi $v0, $0, 10
	syscall
	
#Memory Diagram for get_multiples
	#	i		-8($fp)
	#	count		-4($fp)
	#	saved $fp	($sp)		
	#	saved $ra	4($sp)	
	#	list pointer	8($fp)
	#	n		12($fp)	

get_multiples: # Save $ra and $fp in stack
	addi $sp, $sp, -8 	# make space
	sw $ra, 4($sp) 		# save $ra
	sw $fp, 0($sp) 		# save $fp	
	# Copy $sp to $fp
	addi $fp, $sp, 0	
	# Alloc local variables
	addi $sp, $sp, -8 	#allocate 8 bytes	
	#intializa the local variables
	
	#count = 0
	addi $t0, $0, 0		
	sw $t0, -4($fp) 	#count = 0
	
	addi $t0, $0, 0	
	sw $t0, -8($fp)		#i = 0

	#for i in range(len(the_list)):
loop:	
	lw $t0, -8($fp)		#$t0 = i
	lw $t1, 8($fp)		#$t1 = address pointer of list
	lw $t2, 0($t1)		#$t2 = length of list
	slt $t0, $t0, $t2	#checks if i < than list length
	beq $t0, $0, return_count	#use this line to jump into return count
	
	#if the_list[i] % n == 0 and the_list[i] != n:
	#loading n
	lw $t0, 12($fp) 	#$t0 = n
		
	#loading list[i]
	lw $t1, -8($fp) 	#$t1 = i
	addi $t2, $0, 4 	#t2 = 4
	mult $t1, $t2 		#i*4
	mflo $t1 		#t1 = i*4
	lw $t2, 8($fp)		#$t1 = address pointer of list
	add $t1, $t2, $t1 	#$t1 = address pointer of list + i*4
	lw $t2, 4($t1) 		#$t2 = my_list[i]	
	div $t2, $t0 		#$t2(my_list)%$t0(n)
	mfhi $t1 		#$t1 = the_list[i] % n

	#first if condition: the_list[i] % n == 0
	bne $t1, $0, increment_i  # if the_list[i] % n != 0, go to increment i (do not check next cond)

 	# second if condition: and the_list[i] != n
	lw $t0, -8($fp) 	#$t0 = i
	addi $t1, $0, 4 	#t1 = 4
	mult $t0, $t1 		#i*4
	mflo $t0 		#t0 = i*4
	lw $t1, 8($fp)		#$t1 = address pointer of list
	add $t1, $t0, $t1 	#$t1 = address pointer of list + i*4
	lw $t0, 4($t1) 		#$t0 = my_list[i]
	lw $t1, 12($fp)
	beq $t1, $t0, increment_i	# if the_list[i] == n, go to increment i (don't increment count)
	# if the_list[i] != n, increment the count
	
	#incrementing counter
	lw $t0, -4($fp) 	#$t0 = count
	addi $t0, $t0, 1 	#$t0 = count + 1
	sw $t0, -4($fp) 	#count = $t0

increment_i:	
	#incrementing i
        lw $t0, -8($fp)		#$load i into $t0
        addi $t0,$t0, 1		#increment i by 1
        sw $t0, -8($fp)    	#store i into -8($fp)    	
	j loop

#return count
return_count: 
	#returning the values(callee)
	# Return result in $v0
	lw $v0, -4($fp) 	# $v0 = count	
	# Remove the 2 local vars.
	addi $sp, $sp, 8	
	# Restore $fp and $ra
	lw $fp, 0($sp) 		#restore $fp
	lw $ra, 4($sp) 		#restore $ra
	addi $sp, $sp, 8 	#deallocate	
	#Return to caller
	jr $ra
	
	
	
	
	
	
	
	
	
	
	
	
	
	
