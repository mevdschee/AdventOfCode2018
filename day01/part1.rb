lines = File.readlines('input')
sum = 0
lines.each do |_line|
  sum += _line.to_i
end
puts sum
