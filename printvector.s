# MIPS Assembly Language
# This program provides a polymorphic function 
# to print the contents of a vector of words to the console.

# Also using the swap procedure, it swaps 2 of the array's values.

.data
# vector of 10 integers
intarray: .word 13, 8, 3, 3, 19, 48, 17, 7, 20, 15
messgstr: .asciiz "The vector is:\n"
onespace: .asciiz " "
newline:  .asciiz "\n"

.text   
j main
# printvector function
printvector:
    # $a0 = address of vector
    # $a1 = number of elements
    move $t0, $a0          # pointer to vector
    move $t1, $a1          # array size
loop:
    beq $zero, $t1, end_loop # if size is 0, exit loop
    lw $t2, 0($t0)           # load integer from array
    li $v0, 1                # syscall for print_int
    move $a0, $t2            # move integer to argument register
    syscall                  # print item
    # print space
    li $v0, 4                # syscall for print string
    la $a0, onespace         # load address of space
    syscall                   # print space
    addi $t1, $t1, -1         # decrement number of elements
    addi $t0, $t0, 4          # increment pointer to next element
    j loop                    # jump to loop
end_loop:
# print newline
    li $v0, 4                # syscall for print string
    la $a0, newline           # load address of newline
    syscall                   # print newline
    jr $ra                    # return to caller
    
swap:
    la $t0, intarray
    
    sll $t1, $a0, 2
    sll $t2, $a1, 2
	
    add $t3, $t1, $t0 
    add $t4, $t2, $t0
    lw $t5, 0($t4)
    lw $t6, 0($t3)
    	
    sw $t6, 0($t4)
    sw $t5, 0($t3)
    jr $ra

# main function
main:
    # print message
    la $a0, messgstr      # load address of message
    li $v0, 4            # syscall for print string
    syscall               # print message

    # call printvector function
    la $a0, intarray         # load address of string array
    li $a1, 10               # number of elements in array
    jal printvector          # call printvector function

    li $a0, 0
    li $a1, 9
    jal swap
    
    la $a0, intarray
    li $a1, 10
    jal printvector
    
    # exit program
    li $v0, 10
    syscall
