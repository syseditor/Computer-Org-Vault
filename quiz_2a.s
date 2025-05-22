.data
intarray: .word 13, 8, 3, 3, 19, 48, 17, 7, 20, 15
finalarray: .word 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
onespace: .asciiz " "
newline:  .asciiz "\n"

.text
j main
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

quiz:
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    sw $ra, -4($sp)
loop_quiz:
    lw $t3, 0($t0) # load a word from the source area
    sw $t3, 0($t1) # store it to the destination area
    addi $t0, $t0, 4 # increment base address for source area
    addi $t1, $t1, 4 # increment base address for destination area
    addi $t2, $t2, -1 # decrement count
    blt $zero, $t2, loop_quiz
    lw $ra, -4($sp)
    jr $ra
    
main:
    la $a0, intarray
    li $a1, 10
    jal printvector
    
    la $a0, finalarray
    li $a1, 10
    jal printvector
    
    la $a0, intarray
    la $a1, finalarray
    la $a2, 10
    jal quiz
    
    la $a0, finalarray
    la $a1, 10
    jal printvector
    
    la $v0, 10
    syscall