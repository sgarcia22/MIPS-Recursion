#Second SPIM Assignment
	#Program 2
	#Name: Samantha Garcia
	#Class: CDA 3101 Section 1678
	#Date: 10/01/2017
	
.globl main
main:

.data

str1: .asciiz "Enter the first integer n1: "
str2: .asciiz "Enter the second integer n2: "
str3: .asciiz "The greatest common divisor of n1 and n2 is "
str4: .asciiz "The least common multiple of n1 and n2 is "
str5: .asciiz "Invalid input! Please try again. "
newline: .asciiz "\n"

.text

FIRST_VAR:						#first variable

la $a0, str1					#load str1 into $a0
li $v0, 4						#load I/O sequence into output register
syscall							#execute I/O

li $v0, 5						#reads integer from the console window
syscall
move $s0, $v0					#save inputted int into $s0 -> n1

slt $t0, $s0, $zero				#if n1 < 0
bne $zero, $t0, WRONG_FIRST		#then jump to the end to execute WRONG code

addi $t0, $s0, -255				#if n1 < 255
slt $t0, $zero, $t0			
bne $zero, $t0, WRONG_FIRST 	#jump to error message and ask for input again

SECOND_VAR:						#second variable

la $a0, str2					#load str2 into $a0
li $v0, 4						#load I/O sequence into output register
syscall							#execute I/O

li $v0, 5						#reads integer from the console window
syscall
move $s1, $v0					#save inputted int into $s1 -> n2

addi $t1, $s1, -255				#if n2 < 255
slt $t2, $zero, $t1		
bne $zero, $t2, WRONG_SECOND 	#jump to error message and ask for input again

slt $t1, $s1, $zero				#if n2 < 0
bne $zero, $t1, WRONG_SECOND	#then jump to the end to execute WRONG code

beq $zero, $s0, WRONG_BOTH

CONTINUE:

la $a0, str3					#load str3 into $a0
li $v0, 4						#load I/O sequence into output register
syscall							#execute I/O

addi $sp, $sp, -4				#allocate three words in the stack pointer
sw $ra, 0($sp)					#store return address at the bottom of the stack

move $a0, $s0					#move n1 to arg 0
move $a1, $s1					#move n2 to arg 1

jal GCD							#jump and link to greatest common denominator function

#The function GCD has finished terminating
addi $sp, $sp, 4 				#move the stack pointer up

move $t2, $a0

li $v0, 1						#first service of printing integer loaded
move $a0, $t2					#load n1 to register
syscall							#print
move $t4, $a0					#move input to another register

la $a0, newline			 		#print the newline character
li $v0, 4						#load I/O code to print the newline to console
syscall							#print the newline to console
move $t3, $a0			 		#move input to another register

la $a0, str4					#load str4 into $a0
li $v0, 4						#load I/O sequence into output register
syscall							#execute I/O

addi $sp, $sp, -8				#allocate three words in the stack pointer
sw $s0, 4($sp)					#store n1 in the stack
sw $s1, 0($sp)					#store n2 in the stack

move $a0, $t2

jal LCM							#jump and link to calculate the least common multiple

#The function LCM has finished terminating
addi $sp, $sp, 8 				#move the stack pointer up


li $v0, 1						#first service of printing integer loaded
syscall							#print

jal END

WRONG_FIRST:					#If they entered wrong input

la $a0, str5					#load str5 into $a0
li $v0, 4						#load I/O sequence into output register
syscall							#execute I/O

j FIRST_VAR;

WRONG_SECOND:					#If they entered wrong input

la $a0, str5					#load str5 into $a0
li $v0, 4						#load I/O sequence into output register
syscall							#execute I/O

j SECOND_VAR;

WRONG_BOTH:						#checks if both inputs are 0

beq $zero, $s1, WRONG_FIRST		#if the second variable is also 0, print invalid input and ask for inputs again
j CONTINUE						#if the second variable is not 0, continue the program as usual

GCD:

beq $a1, $zero, returnN2		#if n2 == 0 return n2

addi $sp, $sp, -4				#add a word slot to the stack pointer
sw $ra, 0($sp)					#store the function return address registers in stack pointer

div $a0, $a1					#n1 mod n2 
mfhi $t1						#$t1 is the temporary register for the modulus operation

move $a0, $a1					#move n2 to n1 for function call
move $a1, $t1 					#move n1 mod n2 to n1 for function call

jal GCD							#recursively call the GCD function

lw $ra, 0($sp)					#get to return address for main
addi $sp, $sp, 4				#restore stack pointer word slot
jr $ra							#return to main
 
returnN2:

jr $ra							#jump back to the main function

LCM:

lw $t1, 4($sp)					#load n1 into $t1
lw $t2, 0($sp)					#load n2 into $t1

mult $t1, $t2					#multiply n1 by n2 
mflo $t0						#store n1 * n2 in $t0

div $t0, $a0					#divide n1 * n2 by the calculated gcd
mflo $t3 						#get the quotient of the division and store in $t3

move $a0, $t3					#move the temp register to an argument register

jr $ra							#return to main

END:

li $v0, 10						#syscall code 10 that ends the program 
syscall