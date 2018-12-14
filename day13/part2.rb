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

while carts.count > 1
  carts.keys.sort.each do |key|
    next unless carts[key]

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
    carts.delete(key)
    if carts[y * 1000 + x]
      carts.delete(y * 1000 + x)
    else
      carts[y * 1000 + x] = { dir: dir % 4, turns: turns }
    end
  end
end

key = carts.keys.first
y = key / 1000
x = key % 1000
puts "#{x},#{y}"
