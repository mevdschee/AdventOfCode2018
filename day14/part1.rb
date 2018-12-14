input = IO.read('input').chomp.to_i

recipes = '37'
p1 = 0
p2 = 1

len = 2
done = false
while !done
  n1 = recipes[p1].to_i
  n2 = recipes[p2].to_i
  (n1 + n2).to_s.each_char do |_n|
    recipes[len] = _n
    len+=1
    if len == input + 10
      done = true
      break
    end
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
end

puts recipes[-10..-1]