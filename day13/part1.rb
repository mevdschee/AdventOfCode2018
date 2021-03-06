lines = File.readlines('input')
dirs = '<^>v'

tracks = {}
carts = {}

lines.each_with_index do |line, y|
  line.chomp!
  line.each_char.with_index do |ch, x|
    carts[y * 1000 + x] = { dir: dirs.index(ch), turns: 0 } if dirs.include?(ch)
  end
  line.gsub!(/[##{dirs}]/, dirs.split('').zip(('-|' * 2).split('')).to_h)
  line.each_char.with_index do |ch, x|
    tracks[y * 1000 + x] = ch if ch != ' '
  end
end

collision = nil
while collision.nil?
  carts.keys.sort.each do |key|
    y = key / 1000
    x = key % 1000
    dir = carts[key][:dir]
    turns = carts[key][:turns]
    case dirs[dir]
    when '<'
      x -= 1
    when '^'
      y -= 1
    when '>'
      x += 1
    when 'v'
      y += 1
    end
    left = 3
    right = 1
    case tracks[y * 1000 + x]
    when '/'
      dir += dir.even? ? left : right
    when '\\'
      dir += dir.even? ? right : left
    when '+'
      dir += left + turns % 3
      turns += 1
    end
    if carts[y * 1000 + x]
      collision = "#{x},#{y}"
      break
    else
      carts.delete(key)
      carts[y * 1000 + x] = { dir: dir % 4, turns: turns }
    end
  end
  # (0..lines.count).each do |y|
  #   (0..lines[0].length).each do |x|
  #     key = y * 1000 + x
  #     if collisions[key]
  #       print 'X'
  #     elsif carts[key]
  #       dir = carts[key][:dir]
  #       print dirs[dir]
  #     else
  #       print tracks[key] || ' '
  #     end
  #   end
  #   puts
  # end
  # puts
end

puts collision
