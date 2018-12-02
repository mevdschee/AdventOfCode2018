lines = File.readlines('input').map(&:chomp).map(&:split)
common = ''
lines.product(lines).map do |_line1, _line2|
  common = _line1.zip(_line2).map { |a, b| a if a == b }
  break if common.length == _line1.length - 1
end
puts common
