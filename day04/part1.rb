lines = File.readlines('input')
guards = Hash.new { |guards, guard| guards[guard] = Hash.new(0) }
start = guard = 0
lines.sort.each do |line|
  minute = line.match(/:(\d+)\]/).to_a[1].to_i
  guard = line.match(/#(\d+) /).to_a[1].to_i if line.include? 'begins shift'
  start = minute if line.include? 'falls asleep'
  (start...minute).each { |i| guards[guard][i] += 1 } if line.include? 'wakes up'
end
guard = guards.max_by { |_, v| v.values.sum }[0]
minute = guards[guard].max_by { |_, v| v }[0]
puts guard * minute
