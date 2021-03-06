def addr(registers, instruction)
  _, a, b, c = instruction
  registers[c] = registers[a] + registers[b]
end

def addi(registers, instruction)
  _, a, b, c = instruction
  registers[c] = registers[a] + b
end

def mulr(registers, instruction)
  _, a, b, c = instruction
  registers[c] = registers[a] * registers[b]
end

def muli(registers, instruction)
  _, a, b, c = instruction
  registers[c] = registers[a] * b
end

def banr(registers, instruction)
  _, a, b, c = instruction
  registers[c] = registers[a] & registers[b]
end

def bani(registers, instruction)
  _, a, b, c = instruction
  registers[c] = registers[a] & b
end

def borr(registers, instruction)
  _, a, b, c = instruction
  registers[c] = registers[a] | registers[b]
end

def bori(registers, instruction)
  _, a, b, c = instruction
  registers[c] = registers[a] | b
end

def setr(registers, instruction)
  _, a, _, c = instruction
  registers[c] = registers[a]
end

def seti(registers, instruction)
  _, a, _, c = instruction
  registers[c] = a
end

def gtir(registers, instruction)
  _, a, b, c = instruction
  registers[c] = a > registers[b] ? 1 : 0
end

def gtri(registers, instruction)
  _, a, b, c = instruction
  registers[c] = registers[a] > b ? 1 : 0
end

def gtrr(registers, instruction)
  _, a, b, c = instruction
  registers[c] = registers[a] > registers[b] ? 1 : 0
end

def eqir(registers, instruction)
  _, a, b, c = instruction
  registers[c] = a == registers[b] ? 1 : 0
end

def eqri(registers, instruction)
  _, a, b, c = instruction
  registers[c] = registers[a] == b ? 1 : 0
end

def eqrr(registers, instruction)
  _, a, b, c = instruction
  registers[c] = registers[a] == registers[b] ? 1 : 0
end

lines = File.readlines('input')
lines.map!(&:split)
operations = %w[bani banr muli setr bori eqrr gtir mulr gtrr seti gtri eqri addi borr eqir addr]
opcodes = operations.map.with_index(1).to_h
registers = [1, 0, 0, 0, 0, 0]
ip_register = lines.shift.last.to_i
ip = 0

def sum_of_divisors(n)
  (1..n).select { |i| n % i == 0 }.sum
end

while line = lines[ip]
  operation = line[0]
  instruction = line.map(&:to_i)
  registers[ip_register] = ip
  # print "ip=#{ip} #{registers} #{line.join(' ')} "
  if ip == 1
    registers[0] = sum_of_divisors(registers.max)
    registers[ip_register] += 14
  else
    Object.send(operation, registers, instruction)
  end
  ip = registers[ip_register]
  ip += 1
  # puts registers.to_s
end

puts registers[0]
