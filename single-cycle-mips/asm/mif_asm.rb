MEM_DEPTH = 256

class MifRenderer
  # @params [Array<IR>] irs
  def initialize(width, depth, irs)
    @width = width
    @depth = depth
    @irs = irs
  end

  def render(out)
    render_info(out)
    out.puts
    render_contents(out)
  end

  private

  attr_reader :width, :depth, :irs

  def render_info(out)
    out.puts "WIDTH = #{width};"
    out.puts "DEPTH = #{depth};"
    out.puts "ADDRESS_RADIX = #{address_radix};"
    out.puts "DATA_RADIX = #{data_radix}"
  end

  def render_contents(out)
    out.puts "CONTENT BEGIN"

    addr = 0
    irs.each do |ir|
      raise "#{addr} is out of memory." if addr >= depth
      out.puts "#{sprintf("%x", addr)} : #{sprintf("%032b", ir)};"
      addr += 4
    end

    out.puts "END;"
  end

  def address_radix
    "HEX"
  end

  def data_radix
    "BIN"
  end
end

if __FILE__ == $0
  if ARGV.size != 2
    $stderr.puts "Usage: #{$0} <bin_file> <mif_file_path>"
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

  open("#{ARGV[1]}", "w") do |mif_file|
    MifRenderer.new(32, MEM_DEPTH, irs).render(mif_file)
  end
end
