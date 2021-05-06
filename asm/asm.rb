############################
# ASM -> mif,dat
############################

OP_WIDTH = 4
IM_WIDTH = 8
DEPTH = 16

# @param [String] str
# @return [Boolean]
def is_reg_a(str)
  str == "A"
end

# @param [String] str
# @return [Boolean]
def is_reg_b(str)
  str == "B"
end

# @param [String] str
# @return [Boolean]
def is_im(str)
  return false if str == nil

  (str =~ /\A[0-9]+\z/) != nil
end

# @param [String,Integer] num
# @return [Boolean]
def to_binary(num, width = 4)
  num = num.to_i
  sprintf("%0#{width}b", num)
end

# @param [String,Integer] im
# @return [Boolean]
def to_im(im)
  to_binary(im, IM_WIDTH)
end

class UnknownAsm < StandardError
  def initialize(op, arg1, arg2)
    super("Unknown Asm: '#{op} #{arg1},#{arg2}")
  end
end

module ISA
  # Op codes
  OP_MOV_A_IM = 0b0011
  OP_MOV_B_IM = 0b0111
  OP_MOV_B_A  = 0b0100
  OP_MOV_A_B  = 0b0001
  OP_ADD_A_IM = 0b0000
  OP_ADD_B_IM = 0b0101
  OP_JMP      = 0b1111
  OP_JNC      = 0b1110
  OP_IN_A     = 0b0010
  OP_IN_B     = 0b0110
  OP_OUT_B    = 0b1001
  OP_OUT_IM   = 0b1011
end

class AsmParser
  class << self
    # @param [String] line
    # @return [Array<String>]
    def parse(line)
      line = line.chomp.strip
      result = /\A([a-zA-Z]+)\s+([^,]+)(,\s*(\w*))?\z/.match(line)
      raise "Failed to parse: #{line}" unless result

      op = result.captures[0].upcase
      arg1 = result.captures[1]
      arg2 = result.captures[3]

      return [op, arg1, arg2]
    end
  end
end

class IR
  class << self
    # @param [String] line
    # @return [IR]
    def from_line(line)
      # Parse asm line
      op, arg1, arg2 = AsmParser.parse(line)

      [ # MOV X,X
        ["MOV", :reg_a, :im, ISA::OP_MOV_A_IM, :arg2],
        ["MOV", :reg_b, :im, ISA::OP_MOV_B_IM, :arg2],
        ["MOV", :reg_b, :reg_a, ISA::OP_MOV_B_A, :arg2],
        ["MOV", :reg_a, :reg_b, ISA::OP_MOV_A_B, :zero],
        # ADD X,X
        ["ADD", :reg_a, :im, ISA::OP_ADD_A_IM, :arg2],
        ["ADD", :reg_b, :im, ISA::OP_ADD_B_IM, :arg2],
        # Jump
        ["JMP", :im, :none, ISA::OP_JMP, :arg1],
        ["JNC", :im, :none, ISA::OP_JNC, :arg1],
        # IN
        ["IN", :reg_a, :none, ISA::OP_IN_A, :zero],
        ["IN", :reg_b, :none, ISA::OP_IN_B, :zero],
        # OUT
        ["OUT", :reg_b, :none, ISA::OP_OUT_B, :zero],
        ["OUT", :im, :none, ISA::OP_OUT_IM, :arg1],
      ].each do |pattern|
        next unless pattern[0] == op
        case pattern[1]
        when :reg_a
          next unless is_reg_a(arg1)
        when :reg_b
          next unless is_reg_b(arg1)
        when :im
          next unless is_im(arg1)
        end
        case pattern[2]
        when :reg_a
          next unless is_reg_a(arg2)
        when :reg_b
          next unless is_reg_b(arg2)
        when :im
          next unless is_im(arg2)
        end


        arg = case pattern[4]
        when :arg1
          arg1
        when :arg2
          arg2
        when :zero
          0
        end

        return new(op, pattern[3], arg, arg1, arg2)
      end

      raise UnknownAsm.new(op, arg1, arg2)
    end
  end

  def initialize(op_name, op_code, im, raw_arg1, raw_arg2)
    @op_name = op_name
    @op_code = op_code
    @im = im

    @raw_arg1 = raw_arg1
    @raw_arg2 = raw_arg2
  end

  def to_mif(addr)
    "#{to_binary(addr)} : #{to_binary(op_code, OP_WIDTH)}_#{to_binary(im, IM_WIDTH)}; -- #{op_name} #{raw_arg1},#{raw_arg2}"
  end

  def to_dat
    "#{to_binary(op_code, OP_WIDTH)}#{to_binary(im, IM_WIDTH)}"
  end

  private

  attr_reader :op_name, :op_code, :im, :raw_arg1, :raw_arg2
end

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
      out.puts ir.to_mif(addr)
      addr += 1
    end

    (depth - addr).times do |i|
      out.puts IR.new("JMP", ISA::OP_JMP, 0, 0, nil).to_mif(addr + i)
    end

    out.puts "END;"
  end

  def address_radix
    "BIN"
  end

  def data_radix
    "BIN"
  end
end

class MemRenderer
  def initialize(irs)
    @irs = irs
  end

  def render(out)
    irs.each do |ir|
      out.puts ir.to_dat
    end
  end

  private

  attr_reader :irs
end

if __FILE__ == $0
  if ARGV.size != 2
    $stderr.puts "Usage: #{$0} <mif_file_path> <mem_file_path>"
    return
  end

  irs = []
  while line = $stdin.gets
    irs << IR.from_line(line)
  end

  open("#{ARGV[0]}", "w") do |mif_file|
    MifRenderer.new(OP_WIDTH + IM_WIDTH, DEPTH, irs).render(mif_file)
  end

  open("#{ARGV[1]}", "w") do |mem_file|
    MemRenderer.new(irs).render(mem_file)
  end
end
