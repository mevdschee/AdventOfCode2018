@lines = []
@field = {}
@spring = [0, 0]
@min_y = 0
@max_y = 0

def init(filename)
  @lines = File.readlines(filename)
  @field = Hash.new('.')
  @spring = [500, 0]
  @lines.each do |line|
    line.chomp!
    regex = /[xy]=(\d+), [xy]=(\d+)..(\d+)/
    f, s, e = line.scan(regex).to_a[0].map(&:to_i)
    (s..e).each do |l|
      x, y = line[0] == 'x' ? [f, l] : [l, f]
      @field[[x, y]] = '#'
    end
  end
  @min_y = @field.min_by { |k, _| k[1] }[0][1]
  @max_y = @field.max_by { |k, _| k[1] }[0][1]
end

# def print_field
#   min_x = @field.min_by { |k, _| k[0] }[0][0]
#   min_y = @field.min_by { |k, _| k[1] }[0][1]
#   max_x = @field.max_by { |k, _| k[0] }[0][0]
#   max_y = @field.max_by { |k, _| k[1] }[0][1]
#   (min_y..max_y).each do |y|
#     (min_x..max_x).each do |x|
#       if @spring == [x, y]
#         print '+'
#       else
#         print @field[[x, y]]
#       end
#     end
#     puts
#   end
# end

def fall(fronteers)
  new_fronteers = []
  fronteers.each do |x, y|
    while @field[[x, y + 1]] == '.'
      y += 1
      break if y > @max_y

      @field[[x, y]] = '|'
    end
    new_fronteers << [x, y] if y <= @max_y && @field[[x, y + 1]] != '|'
  end
  new_fronteers
end

def spread(fronteers)
  new_fronteers = []
  fronteers.each do |ox, y|
    walls = []
    [-1, 1].each do |dir|
      x = ox
      while '.|'.include?(@field[[x + dir, y]])
        x += dir
        @field[[x, y]] = '|'
        break if '.|'.include?(@field[[x, y + 1]])
      end
      if '.|'.include?(@field[[x, y + 1]])
        new_fronteers << [x, y]
      else
        walls << [x, y]
      end
    end
    next unless walls.count == 2

    (walls[0][0]..walls[1][0]).each do |x|
      @field[[x, y]] = '~'
    end
    @field[[ox, y - 1]] = '|'
    new_fronteers << [ox, y - 1]
  end
  new_fronteers.uniq
end

def count_characters(characters)
  @field.select do |coordinates, character|
    x, y = coordinates
    matches = characters.include?(character)
    y >= @min_y && y <= @max_y && matches
  end.count
end

init('input')
fronteers = [@spring]
until fronteers.count == 0
  fronteers = fall(fronteers)
  fronteers = spread(fronteers)
end
# print_field
puts count_characters('~|')
