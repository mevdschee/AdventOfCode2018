lines = File.readlines('input')

initial = lines[0].split(':').last.strip

plants = Hash.new('.')
(0...initial.length).each do |i|
  plants[i] = '#' if initial[i] == '#'
end

patterns = Hash.new(false)
lines.each do |line|
  next unless line.include?(' => #')

  pattern = line.split(' => ').first
  patterns[pattern] = true
end

line = initial
20.times do
  min = plants.keys.min - 2
  max = plants.keys.max + 2
  new_plants = Hash.new('.')
  (min..max).each do |p|
    # print plants[p]
    pattern = plants[p - 2] + plants[p - 1] + plants[p] + plants[p + 1] + plants[p + 2]
    new_plants[p] = '#' if patterns[pattern]
  end
  # puts
  plants = new_plants
end

puts plants.keys.sum
