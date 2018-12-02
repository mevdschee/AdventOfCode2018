lines = File.readlines('input')
common = ''
lines.product(lines).map do |_line1, _line2|
  common = ''
  _line1.length.times do |i|
    common += _line1[i] if _line1[i] == _line2[i]
  end
  break if common.length == _line1.length - 1
end
puts common
