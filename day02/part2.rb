lines = File.readlines('input')
common = ''
lines.product(lines).map do |s1, s2|
  common = ''
  s1.length.times do |i|
    common += s1[i] if s1[i] == s2[i]
  end
  break if common.length == s1.length - 1
end
puts common
