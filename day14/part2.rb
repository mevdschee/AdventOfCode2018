input = IO.read('input').chomp

recipes = { 0 => 3, 1 => 7 }
p1 = 0
p2 = 1

len = 2
loop do
  n1 = recipes[p1]
  n2 = recipes[p2]
  (n1 + n2).to_s.split('').map(&:to_i).each do |_n|
    recipes[len] = _n
    len += 1
  end
  p1 = (p1 + 1 + n1) % len
  p2 = (p2 + 1 + n2) % len
  # (0...recipes.length).each do |_p|
  #  if p1 == _p
  #    print '(' + recipes[_p] + ')'
  #  elsif p2 == _p
  #    print '[' + recipes[_p] + ']'
  #  else
  #    print ' ' + recipes[_p] + ' '
  #  end
  # end
  # puts

  next unless len % 10_000 == 0

  puts len
  str = recipes.map { |_i| recipes[_i] }.join('')
  break if recipes.include?(input)
end

puts recipes.index(input)
