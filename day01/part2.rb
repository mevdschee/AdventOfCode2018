lines = File.readlines('input')
sum = 0
seen = {}
lines.cycle do |line|
  sum += line.to_i
  break if seen[sum]

  seen[sum] = true
end
puts sum
