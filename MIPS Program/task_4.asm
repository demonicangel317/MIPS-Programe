# Task 4: Using all MIPS knowledge (conditions, loops, array access, function definition, etc) together.
# --> Recreating the insertion sort function in MIPS, taking an array of integers, to sort them in ascending order.
# Input: [6, -2, 7, 4, -10]
# Expected Output: -10 -2 4 6 7

.globl insertionSort

.data
newLine: .asciiz "\n"
space: .asciiz " "

.text
j main  # jumps execution to the main func code


insertionSort: 
	# |  j     	|<-- -16($fp)
	# |  key   	|<-- -12($fp)
	# |  i	   	|<-- -8($fp)
	# |  len   	|<-- -4($fp)
	# | saved $fp   |<------ $fp
	# | saved $ra   |
	# |  arr 	|<-- 8($fp)

	       addi $sp, $sp, -8 # saving $ra and $fp
	       sw $ra, 4($sp)
	       sw $fp, 0($sp)

	       addi $fp, $sp, 0 # copy sp to fp
	       
	       addi $sp, $sp, -16  # 16 bytes for 4 local vars
	       
	       lw $t0, 8($fp)  # loads arr/list (arg1)
	       lw $t1, 0($t0)  # loads from the array address, which carries len
	       sw $t1, -4($fp)  # <--- local var 1: length = len(the_list)
	       
	       addi $t0, $0, 1  # local var 2:
	       sw $t0, -8($fp)  # <--- i, starts from 1
	       j outerLoop
	       
outerLoop:     # for i in range(1, length) 
	       lw $t0, -8($fp) # i
	       lw $t1, -4($fp) # length
	       slt $t0, $t0, $t1  # is i < length?
	       beq $t0, $0, endOuterLoopAndFunc # if yes (1), dont jump to end, if not (0), jump to outer-end/func end
	       
	       # key = the_list[i]
	       lw $t0, -8($fp)  # i
	       lw $t1, 8($fp) # the_list
	       sll $t0, $t0, 2 # i * 4
	       add $t1, $t1, $t0  # (addr of the_list[i]) - 4
	       lw $t0, 4($t1)
	       sw $t0, -12($fp) # <--- key 
	       
	       # j = i - 1
	       lw $t0, -8($fp)
	       addi $t0, $t0, -1
	       sw $t0, -16($fp)  # <--- j
	       
	      jal innerLoop # while j >= 0 and key < the_list[j] :
	      		    # 		the_list[j + 1] = the_list[j]
                            # 		j -= 1
                            
	       # the_list[j+1] = key
	      lw $t0, 8($fp) # the_list
	      lw $t1, -16($fp) # j
	      addi $t1, $t1, 1  # j + 1
	      sll $t1, $t1, 2  # (j+1) * 4
	      add $t0, $t0, $t1
	      lw $t1, -12($fp)  # $t1 = key
	      sw $t1, 4($t0)  # stores key in the_list[j+1]
	      
	      # i += 1
	      lw $t0, -8($fp)  # i
	      addi $t0, $t0, 1
	      sw $t0, -8($fp) # i += 1
	      
	      # jump back up
	      j outerLoop
	       
innerLoop:     # while j>=0 and key < the_list[j]:

	       # j >= 0 ?
	       lw $t0, -16($fp) # load j
	       slt $t1, $t0, $0   # is j < 0 / NOT j >= 0?
	       bne $t1, $0, endInnerLoop  # if yes, end inner loop (will not check the next condition)
	       
	       # key < the_list[j] ?
	       lw $t0, -12($fp) # key
	       lw $t1, -16($fp) # j
	       lw $t2, 8($fp) # the_list
	       sll $t1, $t1, 2  # j * 4
	       add $t2, $t2, $t1  # (addr of the_list[j]) - 4
	       lw $t1, 4($t2) # the_list[j]
	       slt $t0, $t0, $t1  # is key < the_list[j] ?
	       beq $t0, $0, endInnerLoop  # if yes, continue / if no, end inner loop
	       
	       # the_list[j+1] = the_list[j]
	       lw $t0, 8($fp)  # the_list
	       lw $t1, -16($fp) # j
	       sll $t2, $t1, 2  # j * 4
	       add $t0, $t0, $t2
	       lw $t2, 4($t0)  # takes value from the_list[j]
	       sw $t2, 8($t0)  # hands it over to the_list[j+1]
	       
	       # j -= 1
	       lw $t0, -16($fp)  # j
	       addi $t0, $t0, -1 # j - 1
	       sw $t0, -16($fp)  # j 
	       
	       j innerLoop
	       
endInnerLoop: jr $ra # jumps back to mid-section of outer-loop

endOuterLoopAndFunc: # beginning to return to after func call in main (no returned value, no $v0)
	      addi $sp, $sp, 16 # remove local vars
	      
	      lw $fp, 0($sp) # restore $fp
	      lw $ra, 4($sp) # restore $ra
	      addi $sp, $sp, 8  # deallocate those two spaces for fp and ra
	      
	      jr $ra # return to caller
       	       
	       
      # -4($fp) = arr
main:	 addi $v0, $0, 9 # allocate space
	 addi $t0, $0, 5  # array length
	 addi $t0, $t0, 1  # * 4
	 sll $t0, $t0, 2
	 add $a0, $0, $t0 # ( [(len) elems + 1] * 4 )
	 syscall
	 sw $v0, -4($fp) # address of arr 
	 addi $t0, $0, 5  # len(arr)
	 sw $t0, ($v0)  # will hold len
	 
	# arr = [6, -2, 7, 4, -10]
	 lw $t0, -4($fp) # load arr address
	 addi $t1, $0, 6  # first element
	 sw $t1, 4($t0) # places first element in block 4 addresses away from addr stored in array pointed
	 addi $t1, $0, -2  # second element
	 sw $t1, 8($t0) # 8 addresses away...
	 addi $t1, $0, 7  # third elem
	 sw $t1, 12($t0)  # ...and so on...
	 addi $t1, $0, 4  # fourth elem
	 sw $t1, 16($t0)
	 addi $t1, $0, -10  # fifth elem
	 sw $t1, 20($t0)
	 
	 # insertion_sort(arr)
	 # 1 argument (arr/the_list)
	 addi $sp, $sp, -4  # allocate 4 bytes for 1 arg
	 
	 lw $t0, -4($fp)  # load arr
	 sw $t0, 0($sp)  # puts arr as arg for the function
	 
	 jal insertionSort  # func call
	 addi $sp, $sp, 4 # remove args
	 
	 sw $0, -8($fp) # allocate space for i = 0 (in printloop)
	 j printLoop
	 
printLoop: # for i in range(len(arr)):
           lw $t0, -8($fp) # i
	   lw $t1, -4($fp) 
	   lw $t1, ($t1) # len(arr)
	   slt $t0, $t0, $t1  # is i < len(arr)?
           beq $t0, $0, endPrintLoop # if yes (1), continue. if not (0), end printing loop
          
          # print(arr[i])
          addi $v0, $0, 1  # print int
          lw $t0, -4($fp) # arr
          lw $t1, -8($fp) # i
          sll $t1, $t1, 2 # i*4
          add $t0, $t0, $t1
          lw $t1, 4($t0) # arr[i]
          add $a0, $0, $t1  # gives arr[i] to be printed
          syscall
          
          # end = " "
          addi $v0, $0, 4
          la $a0, space  # gives " " to be printed
          syscall 
          
          lw $t0, -8($fp) # i
          addi $t0, $t0, 1
          sw $t0, -8($fp) # i += 1
          j printLoop  # jump back up
           	 
	 # end the program
endPrintLoop: addi $v0, $0, 4
              la $a0, newLine  # gives "\n" to be printed
              syscall 
	      addi $sp, $sp, 4 # deallocate main local var
	      addi $v0, $0, 10 # exit
              syscall


