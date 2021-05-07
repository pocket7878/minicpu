build: out.bin Makefile

disasm: out.o Makefile
	mips-linux-gnu-objdump -z -d -M no-aliases,reg-names=mips32 $<

crt0.o: crt0.asm Makefile
	mips-linux-gnu-as -o crt0.o crt0.asm

test.o: test.c Makefile
	mips-linux-gnu-gcc -c -mno-abicalls -o test.o test.c

out.o: crt0.o test.o Makefile
	mips-linux-gnu-ld -e start -Ttext=0 -o out.o crt0.o test.o

out.bin: out.o Makefile
	mips-linux-gnu-objcopy --only-section=.text -O binary out.o out.bin