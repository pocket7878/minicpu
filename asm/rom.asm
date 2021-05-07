start:
    nop
    addiu $v0, $zero, 1
    nop
    addi $v0, $v0, 1
    addi $t0, $v0, 1
    jal hoge
hoge:
    bne $t0, $v0, end
    addu $v0, $v0, $v0
    j end
end:
    j end
