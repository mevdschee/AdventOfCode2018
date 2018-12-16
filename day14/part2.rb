input = IO.read('input').chomp

recipes = '37'
p1 = 0
p2 = 1

done = false
until done
  n1 = recipes[p1].to_i
  n2 = recipes[p2].to_i
  (n1 + n2).to_s.each_char do |n|
    recipes.concat(n)
    if recipes[-input.length..-1] == input
      done = true
      break
    end
  end
  p1 = (p1 + 1 + n1) % recipes.length
  p2 = (p2 + 1 + n2) % recipes.length
  # recipes.split('').each_index do |p|
  #  if p1 == p
  #    print '(' + recipes[p] + ')'
  #  elsif p2 == p
  #    print '[' + recipes[p] + ']'
  #  else
  #    print ' ' + recipes[p] + ' '
  #  end
  # end
  # puts
end

puts recipes.length - input.length
