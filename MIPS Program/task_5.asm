The aim of this task is to use our MIPS knowledge (conditions, loops, array access,
#function definition, etc) together again and faithfully translate the recursive function binary search.
#Last Edited: 19/3/2022 08:00
#Input:
#Array length: 5
#Enter num: 1
#Enter num: 20
#Enter num: 30
#Enter num: 31
#Enter num: 35
#Enter target: 1
#Output:
#0
.globl binary_search
.data
new_line: .asciiz "\n"

.text

###################################################################################
#Begining of Main block	
###################################################################################
	# memory diagram for main
        # arr is at -8($fp)
        # index is at  -4($fp)       
	
main:
	#set fp and make space for locals
	add $fp, $sp, $0 	#move $sp into $fp
	addi $sp, $sp, -8 	#allocate 4 bytes for the array pointer and 4 bytes to store the index value
	
	#arr = [1, 5, 10, 11, 12]	
	addi $v0, $0, 9		#enter code to allocate memory
	addi $a0, $0, 24	#add the amount of bytes to allocate
	syscall
	sw $v0, -8($fp)		#-8($fp) = pointer to the list
	addi $t0, $0, 5		#$t0 = 5
	sw $t0, ($v0)		#my_list.length = 1
	
	lw $t0, -8($fp)		#$t0 = pointer to my_list
	addi $t1, $0, 1
	sw $t1, 4($t0) 		#my_list[0] = 1
	addi $t1, $0, 5
	sw $t1, 8($t0) 		#my_list[1] = 5
	addi $t1, $0, 10
	sw $t1, 12($t0) 	#my_list[2] = 10
	addi $t1, $0, 11
	sw $t1, 16($t0) 	#my_list[3] = 11
	addi $t1, $0, 12
	sw $t1, 20($t0) 	#my_list[4] = 12	

	
	#index = binary_search(arr, 11, 0, len(arr) - 1)
	addi $sp, $sp, -16 	#allocating 16(4 arguments) bytes for the arguments in binary searh	
	lw $t0, -8($fp)
	sw $t0, 0($sp) 		#arg1 = pointer to list	
	addi $t0, $0, 11
	sw $t0, 4($sp)		#arg2 = target value	
	addi $t0, $0, 0
	sw $t0, 8($sp)		#arg3 = 0	
	lw $t0, -8($fp)		#t0 = pointer to begining of the array
	lw $t0, ($t0)		#t0 = length of array
	addi $t0, $t0, -1 	#$t0 = length of array - 1
	sw $t0, 12($sp)		#arg4 = length of array - 1	
	jal binary_search	
	addi $sp, $sp, 16 	#dellocate space of binry search arguments
	sw $v0, -4($fp) 	#-4($fp) / {index} = binary_search(arr, 11, 0, len(arr) - 1)	
	
	#print(index)
	lw $t0, -4($fp)		#load the index at $t0
	add $a0, $0, $t0	#load index to $a0
	addi $v0, $0, 1		#enter command in $v0 to print an integer
	syscall
	
	#print new line
	la $t0, new_line	#load in new line
	add $a0, $0, $t0	#add mew line in $a0
	addi $v0, $0, 4		#print line new line
	syscall
	
	#deallocate locals
	lw $t0, -28($fp) 	#$t0 = length of the array
	addi $t1, $0, 4		#$t1 = 4
	mult $t1, $t0		#length of the array*4
	mflo $t0		#$t0 = length of the array*4
	addi $t0, $0, 4		#length of the array*4 + 4
	add $sp, $0, $t0	#deallocate the locals by adding $t0
	
	#exit	
	addi $v0, $0, 10
	syscall
	
	
	
###################################################################################
#End of Main block	
###################################################################################		

###################################################################################
#Binary Seach begining	
###################################################################################

##Memory Diagram##
	#	mid		-4($fp)	
	#	saved $fp	($sp)		
	#	saved $ra	4($sp)
	#	list pointer	8($fp)
	#	target		12($fp)
	#	low		16($fp)
	#	high		20($fp)
	
binary_search:
	# Save $ra and $fp in stack
	addi $sp, $sp, -8 	# make space
	sw $ra, 4($sp) 		# save $ra
	sw $fp, 0($sp) 		# save $fp	
	# Copy $sp to $fp
	addi $fp, $sp, 0
	addi $sp, $sp, -4	#make space for local variables
			
	#if low > high
	lw $t0, 16($fp)		#$t0 = low
	lw $t1, 20($fp)		#$t1 = high	
	slt $t2, $t1, $t0	#checks if high < low
	addi $t1, $0, 1		#$t1 = 1
	bne $t2, $t1, else	#if high > low then jump to else condition
	addi $v0, $0, -1	#if high  low
	addi $sp, $sp, 4	#deallocate  local variables
	lw $fp, 0($sp) 		#restore $fp
	lw $ra, 4($sp) 		#restore $ra
	addi $sp, $sp, 8 	#deallocate
	# return
	jr $ra

else:	
	#else
	#mid = (high + low) // 2
	lw $t0, 16($fp)		#$t0 = low
	lw $t1, 20($fp)		#$t0 = high	
	add $t0, $t0, $t1	#t0 = high + low
	addi $t1, $0, 2		#$t1 = 2	
	div $t0, $t1		#$t0 / $t1 (high+low) / 2
	mflo $t0		#$t0 =mid {(high+low) / 2 }	
	sw $t0, -4($fp) 	#-4($fp) = mid	
	
else_if:	
	#if the_list[mid] == target:
	lw $t0, -4($fp)		#$t0 = mid
	addi $t1, $0, 4		#$t1 = 4
	mult $t1, $t0		#mid*4
	mflo $t0		#$t0 = mid*4
	lw $t1, 8($fp) 		#t1 = pointer to begining of the list	
	add $t1, $t1, $t0 	#t1 = pointer address + mid aount*bytes
	addi $t1, $t1, 4	#t1 = pointer address + mid aount + 4bytes	
	lw $t2, 0($t1)		#t2 = the_list[mid]	
	lw $t3, 12($fp)		#$t3 = target value		
	bne $t2, $t3, else_else_if #if the_list[mid] != target: jump to else if condition	
	#return mid	
	lw $v0, -4($fp)
	addi $sp, $sp, 4	#deallocate  local variables
	lw $fp, 0($sp) 		#restore $fp
	lw $ra, 4($sp) 		#restore $ra
	addi $sp, $sp, 8 	#deallocate
	# return
	jr $ra	

else_else_if:	
	#if the_list[mid] > target:
	lw $t0, -4($fp)		#$t0 = mid
	addi $t1, $0, 4		#$t1 = 4
	mult $t1, $t0		#mid*4
	mflo $t0		#$t0 = mid*4
	lw $t1, 8($fp) 		#t1 = pointer to begining of the list	
	add $t1, $t1, $t0 	#t1 = pointer address + mid aount*bytes
	addi $t1, $t1, 4	#t1 = pointer address + mid aount + 4bytes	
	lw $t2, 0($t1)		#t2 = the_list[mid]	
	lw $t3, 12($fp)		#$t3 = target value
	slt $t1, $t3, $t2 	#if $t3 < t2 (target value < the_list[mid]) : $t1 = 1
	addi $t4, $0, 1		#$t4 = 1
	bne $t1, $t4, else_else	#if target value > the_list[mid] then jump to else condition
	
	#Recursive Call
	# return binary_search(the_list, target, low, mid - 1)
	addi $sp, $sp, -16 #alloc space	
	lw $t0, 8($fp)
	sw $t0, 0($sp) 		#arg1 = pointer to list	
	lw $t0, 12($fp)
	sw $t0, 4($sp)		#arg2 = target value	
	lw $t0, 16($fp)
	sw $t0, 8($sp)		#arg3 = low	
	#loading mid	
	lw $t0, -4($fp)		#$t0 = mid
	addi $t0, $t0, -1	#$t0 = mid - 1	
	sw $t0, 12($sp)		#arg4 = new high	
	jal binary_search	
	addi $sp, $sp, 16	#deallocate argument space created for recursive call
	addi $sp, $sp, 4	#deallocate  local variables
	lw $fp, 0($sp) 		#restore $fp
	lw $ra, 4($sp) 		#restore $ra
	addi $sp, $sp, 8 	#deallocate
	# return
	jr $ra

else_else:	
	#else
	# Recursive call.
	# return binary_search(the_list, target, mid + 1, high)
	addi $sp, $sp, -16 	#alloc space for 4 arguments	
	lw $t0, 8($fp)
	sw $t0, 0($sp) 		#arg1 = pointer to list	
	lw $t0, 12($fp)
	sw $t0, 4($sp)		#arg2 = target value	
	lw $t0, -4($fp)		#$t0 = mid
	addi $t0, $t0, 1	#$t0 = mid + 1	
	sw $t0, 8($sp)		#arg3 = new low
	lw $t0, 20($fp)		#$t0 = high
	sw $t0, 12($sp)		#arg4 = high	
	jal binary_search	
	addi $sp, $sp, 16	#deallocate argument space created for recursive call
	addi $sp, $sp, 4	#deallocate  local variables
	lw $fp, 0($sp) 		#restore $fp
	lw $ra, 4($sp) 		#restore $ra
	addi $sp, $sp, 8 	#dealloc
	# return
	jr $ra
	
	
	
###################################################################################
#Binary Seach end	
###################################################################################


	
	
	
	
		
	
