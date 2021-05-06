class MemRenderer
  def initialize(irs)
    @irs = irs
  end

  def render(out)
    irs.each do |ir|
      out.puts sprintf("%032b", ir)
    end
  end

  private

  attr_reader :irs
end

if __FILE__ == $0
  if ARGV.size != 2
    $stderr.puts "Usage: #{$0} <bin_file> <mem_file_path>"
    return
  end

  irs = []
  open(ARGV[0], "rb") do |bin_file|
    # Read each 4byte (32-bit)
    while instr = bin_file.read(4)
      instr = instr.unpack("N").first
      irs << instr;
    end
  end

  open("#{ARGV[1]}", "w") do |mem_file|
    MemRenderer.new(irs).render(mem_file)
  end
end
