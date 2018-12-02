lines = File.readlines('input')
common = ''
lines.product(lines).map do |s1, s2|
  common = s1.split('').zip(s2.split('')).map { |c1, c2| c1 if c1 == c2 }.join('')
  break if common.length == s1.length - 1
end
puts common
