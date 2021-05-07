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

$(ROM_BIN_FILE): asm/c/test.c asm/c/crt0.asm
	cd asm/c; $(MAKE) build; cd ../; cp c/out.bin rom.bin

$(CDF_FILE): $(SRC)
	quartus_sh --flow compile $(PROJECT)
