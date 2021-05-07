start:
    nop
    addiu $v0, $zero, 1
    nop
    addi $v0, $v0, 1
    addu $v0, $v0, $v0
    j end
end:
    j end
