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
1000.times do
  min = plants.keys.min - 3
  max = plants.keys.max + 3
  new_plants = Hash.new('.')
  (min..max).each do |p|
    # print plants[p]
    pattern = plants[p - 2] + plants[p - 1] + plants[p] + plants[p + 1] + plants[p + 2]
    new_plants[p] = '#' if patterns[pattern]
  end
  # puts
  diff = new_plants.keys.sum - plants.keys.sum
  # puts diff
  plants = new_plants
end

puts plants.keys.sum + (50_000_000_000 - 1000) * diff
