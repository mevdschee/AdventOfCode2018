lines = File.readlines('input.test')

field = Hash.new('.')
spring = [500, 0]

lines.each do |line|
  line.chomp!
  regex = /[xy]=(\d+), [xy]=(\d+)..(\d+)/
  f,s,e = line.scan(regex).to_a[0].map(&:to_i)
  min_x, min_y = spring
  max_x, max_y = spring
  (s..e).each do |l|
    x, y = line[0]=='x' ? [f,l] : [l,f]
    field[[x,y]] = '#'
    min_x = x if x<min_x
    min_y = y if y<min_y
    max_x = x if x>max_x
    max_y = y if y>max_y
  end
end


