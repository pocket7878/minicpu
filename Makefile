PROJECT=MINI_CPU
SRC=src/*.sv
CDF_FILE=output_files/MINI_CPU.cdf
ASM_FILE=asm/rom.asm
ROM_MIF_FILE=src/rom.mif
ROM_MEM_FILE=./rom.mem

compile: $(CDF_FILE)
	quartus_sh --flow compile $(PROJECT)

program: $(SOF_FILE)
	quartus_pgm -c "USB-Blaster [1-1.4]" $(CDF_FILE)

asm: $(ASM_FILE)
	@ruby asm/asm.rb $(ROM_MIF_FILE) $(ROM_MEM_FILE) < $(ASM_FILE)

$(CDF_FILE): $(SRC)
	quartus_sh --flow compile $(PROJECT)