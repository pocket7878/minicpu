############################
# ASM -> SystemVerilog lines
############################

OP_WIDTH = 4
IM_WIDTH = 8

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

# @param [String] op
# @param [String] arg1
# @param [String,nil] arg2
# @return [String]
def asm_op(op, arg1, arg2)
  case op
  when "MOV"
    if is_reg_a(arg1) && is_im(arg2)
      "0011_#{to_im(arg2)}"
    elsif is_reg_b(arg1) && is_im(arg2)
      "0111_#{to_im(arg2)}"
    elsif is_reg_b(arg1) && is_reg_a(arg2)
      "0100_#{to_im(0)}"
    elsif is_reg_a(arg1) && is_reg_b(arg2)
      "0001_#{to_im(0)}"
    else
      raise UnknownAsm.new(op, arg1, arg2)
    end
  when "ADD"
    if is_reg_a(arg1) && is_im(arg2)
      "0000_#{to_im(arg2)}"
    elsif is_reg_b(arg1) && is_im(arg2)
      "0101_#{to_im(arg2)}"
    else
      raise UnknownAsm.new(op, arg1, arg2)
    end
  when "JMP"
    if is_im(arg1)
      "1111_#{to_im(arg1)}"
    else
      raise UnknownAsm.new(op, arg1, arg2)
    end
  when "JNC"
    if is_im(arg1)
      "1111_#{to_im(arg1)}"
    else
      raise UnknownAsm.new(op, arg1, arg2)
    end
  when "OUT"
    if is_reg_b(arg1)
      "1001_#{to_im(0)}"
    elsif is_im(arg1)
      "1011_#{to_im(arg1)}"
    else
      raise UnknownAsm.new(op, arg1, arg2)
    end
  when "IN"
    if is_reg_a(arg1)
      "0010_#{to_im(0)}"
    elsif is_reg_b(arg1)
      "0110_#{to_im(0)}"
    else
      raise UnknownAsm.new(op, arg1, arg2)
    end
  else
      raise UnknownAsm.new(op, arg1, arg2)
  end
end

MAX_LINUM = 16

if __FILE__ == $0
  linum = 0
  while line = gets
    if linum >= MAX_LINUM
      raise "Assembly must be less than #{MAX_LINUM} lines."
    end

    line = line.chomp.strip
    result = /\A([a-zA-Z]+)\s+([^,]+)(,\s*(\w*))?\z/.match(line)
    unless result
      raise "Unexpected line: '#{line}'"
    end
    op = result.captures[0].upcase
    arg1 = result.captures[1]
    arg2 = result.captures[3]
    asm = asm_op(op, arg1, arg2)
    puts "4'b#{to_binary(linum, OP_WIDTH)}: out=#{OP_WIDTH + IM_WIDTH}'b#{asm}; // #{op} #{arg1},#{arg2}"
    linum += 1
  end
  puts "default: out=#{OP_WIDTH + IM_WIDTH}'b#{asm_op("JMP", "0", nil)}; // JMP 0,"
end
