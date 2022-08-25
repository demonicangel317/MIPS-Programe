The aim of this task is to implement FOR loops, array list and different decisions making(>=, <=, < and >) 
#Last Edited: 25/3/2022 22:30
#Input:
 #Enter array length: 3
 #Enter n: 2
 #Enter the value: 1
 #Enter the value: 2
 #Enter the value: 4
#Output:
 #The number of multiples (excluding itself) = 1

.data
prompt1: .asciiz "Enter array length: "
prompt2: .asciiz "Enter n: "
prompt3: .asciiz "Enter the value: "
result: .asciiz "\nThe number of multiples (excluding itself) = "

count: .word 0
size: .word 0
n: .word 0
theList: .word 0
i: .word 0

.text
main:
    # size = int(input("Enter array length: "))
	la $a0 , prompt1 
	addi $v0 , $0 , 4 
	syscall 

	addi $v0 , $0 , 5
	syscall
	sw $v0 , size

    # the_list = [None]*size 
	addi $v0 , $0 , 9 # allocate space of array
	lw $t0 , size
	sll $t1 , $t0 , 2 # size *4 bytes for the elements
	addi $a0 , $t1 , 4 # extra 4 bytes for the length
	syscall
	sw $v0 , theList # theList point to array address 
	sw $t0 , ($v0) # storing the length of theList in size

    # n = int(input("Enter n: "))
	addi $v0, $0, 4 
	la $a0, prompt2
 	syscall

 	addi $v0, $0, 5 
 	syscall
 	sw $v0, n


# for i in range(len(the_list)):
loop:
	lw $t2, i
	lw $t1, size
	slt $s0, $t2, $t1 # if i<len of theList
 	beq $s0, $0, endloop # if not, go to endloop
 	
 	#print enter the value:
    	la $a0 , prompt3
    	addi $v0 , $0 , 4
    	syscall

       # the_list[i] = int(input("Enter the value: "))
    	lw $t0 , i
    	lw $t1 , theList
    	sll $t0 , $t0 , 2 # i *4
    	add $t0 , $t0 , $t1 
    	addi $v0 , $0 , 5 # read value by user input
    	syscall
    	sw $v0 , 4( $t0 ) # the_list[i] = value
    
    	#i += 1
     	lw $t1 , i
    	addi $t1 , $t1 , 1
    	sw $t1 , i

	#if the_list[i] % n == 0
     	lw $t1, n
     	lw $t2, 4($t0) # $t2 = the_list[i]
 	div $t2, $t1 
 	mfhi $t3 # $t3 = remainder
 	beq $t3, $0, condition2 #if the remainder = 0, jump to condtion 2
 	j loop
 	
condition2:	
 # the_list[i] != n
 	lw $t1, n
 	lw $t2, 4($t0) # $t2 = the_list[i]
 	bne $t2, $t1, addition # if the value != n, jump to addition
 	j loop
  
addition:
	# count += 1
   	lw $t1, count          
        addi $t1, $t1, 1       
        sw $t1, count 

    	# restart the loop
	j loop
    
endloop:
	# print("\nThe number of multiples (excluding itself) = " + str(count))
 	addi $v0, $0, 4
 	la $a0, result
 	syscall

 	lw $t1, count
 	add $a0, $0, $t1 #load count into $a0 for printing
 	addi $v0, $0, 1
 	syscall


End:
    	# Exit the program
    	addi $v0 , $0 , 10
    	syscall
