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
diff = 0
(0...1000).each do |_i|
  min = plants.keys.min - 3
  max = plants.keys.max + 3
  new_plants = Hash.new('.')
  (min..max).each do |_p|
    # print plants[_p]
    pattern = plants[_p - 2] + plants[_p - 1] + plants[_p] + plants[_p + 1] + plants[_p + 2]
    new_plants[_p] = '#' if patterns[pattern]
  end
  # puts
  diff = new_plants.keys.sum - plants.keys.sum
  # puts diff
  plants = new_plants
end

puts plants.keys.sum + (50_000_000_000 - 1000) * diff
