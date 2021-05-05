PROJECT=MINI_CPU
SRC=src/*.sv
CDF_FILE=output_files/MINI_CPU.cdf

compile: $(CDF_FILE)
	quartus_sh --flow compile $(PROJECT)

program: $(SOF_FILE)
	quartus_pgm -c "USB-Blaster [1-1.4]" $(CDF_FILE)

asm: asm/rom.asm
	@ruby asm/asm.rb < asm/rom.asm

$(CDF_FILE): $(SRC)
	quartus_sh --flow compile $(PROJECT)