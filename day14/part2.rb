input = IO.read('input').chomp
input_len = input.length

recipes = ' ' * 1024 * 1024 * 1024
recipes[0] = '3'
recipes[1] = '7'
p1 = 0
p2 = 1

pos = 2
done = false
until done
  n1 = recipes[p1].to_i
  n2 = recipes[p2].to_i
  (n1 + n2).to_s.each_char do |_n|
    recipes[pos] = _n
    pos += 1
    if recipes[pos - input_len...pos] == input
      done = true
      break
    end
  end
  p1 = (p1 + 1 + n1) % pos
  p2 = (p2 + 1 + n2) % pos
  # (0...recipes.posgth).each do |_p|
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

puts pos - input_len
