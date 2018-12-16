tests, instructions = IO.read('input').chomp.split("\n\n\n")
tests = tests.split("\n\n")
tests.map! { |v| v.split("\n") }

def addr(registers, instructions)
  _, a, b, c = instructions
  registers[c] = registers[a] + registers[b]
  end

def addi(registers, instructions)
  _, a, b, c = instructions
  registers[c] = registers[a] + b
end

def mulr(registers, instructions)
  _, a, b, c = instructions
  registers[c] = registers[a] * registers[b]
end

def muli(registers, instructions)
  _, a, b, c = instructions
  registers[c] = registers[a] * b
end

def banr(registers, instructions)
  _, a, b, c = instructions
  registers[c] = registers[a] & registers[b]
end

def bani(registers, instructions)
  _, a, b, c = instructions
  registers[c] = registers[a] & b
end

def borr(registers, instructions)
  _, a, b, c = instructions
  registers[c] = registers[a] | registers[b]
end

def bori(registers, instructions)
  _, a, b, c = instructions
  registers[c] = registers[a] | b
end

def setr(registers, instructions)
  _, a, _, c = instructions
  registers[c] = registers[a]
end

def seti(registers, instructions)
  _, a, _, c = instructions
  registers[c] = a
end

def gtir(registers, instructions)
  _, a, b, c = instructions
  registers[c] = a > registers[b] ? 1 : 0
end

def gtri(registers, instructions)
  _, a, b, c = instructions
  registers[c] = registers[a] > b ? 1 : 0
end

def gtrr(registers, instructions)
  _, a, b, c = instructions
  registers[c] = registers[a] > registers[b] ? 1 : 0
end

def eqir(registers, instructions)
  _, a, b, c = instructions
  registers[c] = a == registers[b] ? 1 : 0
end

def eqri(registers, instructions)
  _, a, b, c = instructions
  registers[c] = registers[a] == b ? 1 : 0
end

def eqrr(registers, instructions)
  _, a, b, c = instructions
  registers[c] = registers[a] == registers[b] ? 1 : 0
end

def match(method, registers, instructions, expected)
  registers = registers.dup
  Object.send(method, registers, instructions)
  registers == expected
end

result = 0
tests.each do |lines|
  registers_regex = /\[(\d+), (\d+), (\d+), (\d+)\]/
  instructions_regex = /(\d+) (\d+) (\d+) (\d+)/
  registers = lines[0].scan(registers_regex).to_a[0].map(&:to_i)
  instructions = lines[1].scan(instructions_regex).to_a[0].map(&:to_i)
  expected = lines[2].scan(registers_regex).to_a[0].map(&:to_i)
  operations = %i[addr addi mulr muli banr bani borr bori setr seti gtir gtri gtrr eqir eqri eqrr]
  matches = operations.select { |method| match(method, registers, instructions, expected) }
  result += 1 if matches.count >= 3
end
puts result
