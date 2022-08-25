The aim of this task is to implement in MIPS different decisions (>=, <=, < and >), complex if-then-elses, and shift instructions to multiply or divide, as needed.
#Last Edited: 19/3/2022 08:00
#Input:
 #Enter the number: 60
 #Enter the first divisor: 6
 #Enter the second divisor: 10
#Output:
 #Divisors: 2
 
.data
str1:            .asciiz "Enter the number: "
str2:		 .asciiz "Enter the first divisor: "
str3:		 .asciiz "Enter the second divisor: "
str4:		 .asciiz"\nDivisors: "
number:		 .word 0
first_divisor:   .word 0
second_divisor:	 .word 0
divisors:	 .word 0

.text 
#print "Enter the number: "
addi $v0,$0,4		#system call 5(print string)
la $a0,str1		#print "Enter the number: "
syscall			#print

#get user's input (number)
addi $v0,$0,5		#system call 5(input integer)
syscall			#result is in $v0
sw   $v0,number		#store user's input in variable number

#print "Enter the first divisor: "
addi $v0,$0,4		#system call 4(print string)
la $a0,str2		#print "Enter the first divisor: "
syscall	

#get user's input (first_divisor)
addi $v0,$0,5				#system call 5(input integer)
syscall					#result is in $v0
sw   $v0,first_divisor			#store user's input in first_divisor

#print "Enter the second divisor: "
addi $v0,$0,4				#system call 4(print string)
la $a0,str3				#print  "Enter the second divisor: "
syscall	

#get user's input (second_divisor)
addi $v0,$0,5				#system call 5(input integer)
syscall					#result is in $v0
sw   $v0,second_divisor			#store user's input in second_divisor

#perform number % first_divisor
lw   $t0,number				#load data in $t0 into number
lw   $t1,first_divisor			#load data in $t1 into first_divisor
div  $t0,$t1				#$t0/$t1(number/first_divisor)
mfhi $t3				#store quotient in $t3
beq  $t3,$0,check_second_divisor	#check if $t3(quotient) == 0,if yes,check second divisor,if no go to elif
j elif

#and operation to check second divisor
check_second_divisor:
lw   $t0,number				#load data in $t0 into number
lw   $t2,second_divisor			#load data in $t2 into second_divisor
div  $t0,$t2		                #$t0/$t1(number/second_divisor)
mfhi $t3				#store quotient in $t3
beq  $t3,$0,store2			#check if $t3(quotient) == 0,if yes,go to store2,if no go to elif
j elif

#store 2 into divisors
store2:
addi $t3,$0,2				#add 2 in $t3
sw   $t3,divisors			#store value in $t3(2) into variable divisors
j print					#jump print

#elif condition
elif:
lw   $t0,number				#load data in $t0 into number
lw   $t1,first_divisor			#load data in $t1 into first_divisor
div  $t0,$t1				#$t0/$t1(number/first_divisor)
mfhi $t3				#store quotient in $t3
beq  $t3,$0,store1			#check if $t3(quotient) == 0,if yes,go to store1,if no checkSecondDivisor
j checkSecondDivisor			#jump checkSecondDivisor

#store 1 into divisors
store1:
addi $t3,$0,1				#add 1 in $t3
sw   $t3,divisors			#store value in $t3(1) into variable divisors
j print					#jump print

#or operation to check second divisor
checkSecondDivisor:
lw   $t0,number				#load data in $t0 into number
lw   $t2,second_divisor			#load data in $t2 into second_divisor	
div  $t0,$t2				#$t0/$t2(number/second_divisor)
mfhi $t3				#store quotient in $t3
beq  $t3,$0,store1	                #check if $t3(quotient) == 0,if yes,go to Store1,if no jump to else
j else

else:
addi $t3,$0,0				#add 0 in $t3
sw   $t3,divisors			#store value in $t3(0) into variable divisors

#print
print:
addi $v0,$0,4		#system call 5(print string)
la $a0,str4		#print "\nDivisors: "
syscall	

addi $v0,$0,1		#system call 1(print integer)
lw   $a0,divisors	#load word from divisors into $a0
syscall

addi $v0,$0,10          #exit
syscall

