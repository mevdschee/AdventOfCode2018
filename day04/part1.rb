lines = File.readlines('input')
guards = Hash.new { |guards, guard| guards[guard] = Hash.new(0) }
start = 0; guard = 0
lines.sort.each do |_line|
  minute = _line.match(/:(\d+)\]/).to_a[1].to_i
  guard = _line.match(/#(\d+) /).to_a[1].to_i if _line.include? 'begins shift'
  start = minute if _line.include? 'falls asleep'
  (start...minute).each { |i| guards[guard][i] += 1 } if _line.include? 'wakes up'
end
guard = guards.max_by { |_, v| v.values.sum }[0]
minute = guards[guard].max_by { |_, v| v }[0]
puts guard * minute
