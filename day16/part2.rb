tests, instructions = IO.read('input').chomp.split("\n\n\n\n")
tests = tests.split("\n\n")
tests.map! { |v| v.split("\n") }
instructions = instructions.split("\n")
instructions.map! { |v| v.split(' ').map(&:to_i) }

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

def match(method, registers, instruction, expected)
  registers = registers.dup
  Object.send(method, registers, instruction)
  registers == expected
end

results = {}
tests.each do |lines|
  registers_regex = /\[(\d+), (\d+), (\d+), (\d+)\]/
  instruction_regex = /(\d+) (\d+) (\d+) (\d+)/
  registers = lines[0].scan(registers_regex).to_a[0].map(&:to_i)
  instruction = lines[1].scan(instruction_regex).to_a[0].map(&:to_i)
  expected = lines[2].scan(registers_regex).to_a[0].map(&:to_i)
  operations = %i[addr addi mulr muli banr bani borr bori setr seti gtir gtri gtrr eqir eqri eqrr]
  matches = operations.select { |method| match(method, registers, instruction, expected) }
  if results[instruction[0]].nil?
    results[instruction[0]] = matches
  else
    results[instruction[0]] &= matches
  end
end

operations = {}
results.length.times do
  results = results.sort_by { |_, v| v.length }.to_h
  opcode, operation = results.first.flatten
  operations[opcode] = operation
  results.delete(opcode)
  results = results.map { |k, v| [k, v - [operation]] }.to_h
end

registers = [0, 0, 0, 0]
instructions.each do |instruction|
  opcode = instruction[0]
  operation = operations[opcode]
  Object.send(operation, registers, instruction)
end

puts registers[0]
