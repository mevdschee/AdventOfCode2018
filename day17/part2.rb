@field = Hash.new('.')
@min_y = 0
@max_y = 0

def init(filename)
  File.readlines(filename).each do |line|
    regex = /[xy]=(\d+), [xy]=(\d+)..(\d+)/
    f, s, e = line.scan(regex).to_a[0].map(&:to_i)
    (s..e).each do |l|
      x, y = line[0] == 'x' ? [f, l] : [l, f]
      @field[[x, y]] = '#'
    end
  end
  @min_y = @field.keys.map(&:last).min
  @max_y = @field.keys.map(&:last).max
end

def fall(frontiers)
  new_frontiers = []
  frontiers.each do |x, y|
    while @field[[x, y + 1]] == '.'
      y += 1
      break if y > @max_y

      @field[[x, y]] = '|'
    end
    new_frontiers << [x, y] if y <= @max_y && @field[[x, y + 1]] != '|'
  end
  new_frontiers
end

def spread(frontiers)
  new_frontiers = []
  frontiers.each do |ox, y|
    walls = []
    [-1, 1].each do |dir|
      x = ox
      while '.|'.include?(@field[[x + dir, y]])
        x += dir
        @field[[x, y]] = '|'
        break if '.|'.include?(@field[[x, y + 1]])
      end
      if '.|'.include?(@field[[x, y + 1]])
        new_frontiers << [x, y]
      else
        walls << [x, y]
      end
    end
    next unless walls.count == 2

    (walls[0][0]..walls[1][0]).each do |x|
      @field[[x, y]] = '~'
    end
    @field[[ox, y - 1]] = '|'
    new_frontiers << [ox, y - 1]
  end
  new_frontiers.uniq
end

def count_characters(characters)
  @field.keys.select do |x, y|
    characters.include?(@field[[x, y]]) && @min_y <= y && y <= @max_y
  end.count
end

init('input')
frontiers = [[500, 0]]
until frontiers.count == 0
  frontiers = fall(frontiers)
  frontiers = spread(frontiers)
end
puts count_characters('~')
