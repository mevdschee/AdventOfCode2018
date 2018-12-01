lines = File.readlines('input')
sum = 0
seen = {}
lines.cycle do |_line|
  sum += _line.to_i
  break if seen[sum]
  seen[sum] = true
end
puts sum
