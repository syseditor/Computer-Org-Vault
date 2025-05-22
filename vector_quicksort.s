# MIPS Assembly Language
# This program provides a polymorphic function 
# to print the contents of a vector of words to the console.

# Also using the swap procedure, it swaps 2 of the array's values.
# Main purpose of the program is to implement the Quick Sort algorithm for a specific array.

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
    lw $s1, 0($a0)
    lw $s2, 0($a1)
    	
    sw $s2, 0($a0)
    sw $s1, 0($a1)
    jr $ra

partition:
    move $t5, $ra #current return address
    move $t6, $a0 #left
    move $t7, $a1 #right
    
    sub $t0, $t7, $t6
    srl $t0, $t0, 3 #half the size of the array basically
    sll $t0, $t0, 2 #fixes the pointer position, it gives the correct offset (multiple of 4)
    add $t0, $t6, $t0 #pivot
    lw $t1, 0($t0) #pval
partition_loop:
    sle $t2, $t6, $t7
    beq $t2, $zero, exit_partition_loop
left_loop:
    lw $t3, 0($t6) #*left (changing)
    slt $t2, $t3, $t1
    beq $t2, $zero, right_loop
    addi $t6, $t6, 4
    j left_loop
right_loop:
    lw $t4, 0($t7) #*right (changing)
    slt $t2, $t1, $t4
    beq $t2, $zero, exit_right_loop
    addi $t7, $t7, -4
    j right_loop
exit_right_loop:
    slt $t2, $t6, $t7 #if (left <= right)
    beq $t2, $zero, exit_partition_loop
    
    move $a0, $t6
    move $a1, $t7
    jal swap #swap(left, right)
    
    addi $t6, $t6, 4
    addi $t7, $t7, -4
    j partition_loop
exit_partition_loop:
    move $v0, $t6
    jr $t5

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
    
    li $t0, 0
    li $t1, 9
    la $t2, intarray
    
    sll $t0, $t0, 2
    sll $t1, $t1, 2
	
    add $a0, $t0, $t2 
    add $a1, $t1, $t2
    jal partition
    
    la $a0, intarray
    li $a1, 10
    jal printvector
    
    # exit program
    li $v0, 10
    syscall
