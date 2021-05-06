PROJECT=MINI_CPU
SRC=src/*.sv
CDF_FILE=output_files/MINI_CPU.cdf

ASM_FILE=asm/rom.asm

ROM_OBJ_FILE=asm/rom.o
ROM_BIN_FILE=asm/rom.bin

ROM_MIF_FILE=src/rom.mif
ROM_MEM_FILE=./rom.mem

compile: $(CDF_FILE)
	quartus_sh --flow compile $(PROJECT)

program: $(SOF_FILE)
	quartus_pgm -c "USB-Blaster [1-1.4]" $(CDF_FILE)

asm: $(ROM_MEM_FILE) $(ROM_MIF_FILE)

$(ROM_MEM_FILE): $(ROM_BIN_FILE) asm/mem_asm.rb
	ruby asm/mem_asm.rb $(ROM_BIN_FILE) $(ROM_MEM_FILE)

$(ROM_MIF_FILE): $(ROM_BIN_FILE) asm/mif_asm.rb
	ruby asm/mif_asm.rb $(ROM_BIN_FILE) $(ROM_MIF_FILE)

$(ROM_BIN_FILE): $(ROM_OBJ_FILE)
	mips-linux-gnu-objcopy --only-section=.text -O binary $(ROM_OBJ_FILE) $(ROM_BIN_FILE)

$(ROM_OBJ_FILE): $(ASM_FILE)
	mips-linux-gnu-as -O0 -o $(ROM_OBJ_FILE) $(ASM_FILE)

$(CDF_FILE): $(SRC)
	quartus_sh --flow compile $(PROJECT)
