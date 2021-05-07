start:
    nop
    addiu $v0, $zero, 1
    nop
    addi $v0, $v0, 1
    jal hoge
    j end
hoge:
    addu $v0, $v0, $v0
    jr $ra
    addi $v0, $v0, 1
end:
    j end
