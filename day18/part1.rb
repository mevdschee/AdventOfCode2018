
# An open acre will become filled with trees if three or more adjacent acres contained trees. Otherwise, nothing happens.
# An acre filled with trees will become a lumberyard if three or more adjacent acres were lumberyards. Otherwise, nothing happens.
# An acre containing a lumberyard will remain a lumberyard if it was adjacent to at least one other lumberyard and at least one acre containing trees. Otherwise, it becomes open.
#
# open ground (.), trees (|), or a lumberyard (#)

@field = {}

def init(filename)
    File.readlines('input').each do |line, y|
        line.chomp.split('').each |char, x|
            field[[x,y]]=char
        end
    end
end

def neighbours(ox,oy)
    (-1..1).each do |dy|
        (-1..1).each do |dx|
            if dx!=0 || dy!=0
                x = ox + dx
                y = oy + dy
                yield [x,y] if @field[[x,y]]!=nil
            end
        end
    end
end

def count_neighbours(x,y,c)
    neighbours(x,y).select {|x,y| @field[x]==c}.count
end

def print_field
  min_x = @field.keys.map(&:first).min
  min_y = @field.keys.map(&:last).min
  max_x = @field.keys.map(&:first).max
  max_y = @field.keys.map(&:last).max
  (min_y..max_y).each do |y|
    (min_x..max_x).each do |x|
      print @field[[x, y]]
    end
    puts
  end
end


init('input.test')


10.times do
    print_field
    new_field = {}
    field.each do |coordinates, char|
        x,y = coordinates
        case char
        when '.'
            char = '|' if count_neighbours(x,y,'|')>=3
        when '|'
            char = '#' if count_neighbours(x,y,'#')>=3
        when '#'
            if count_neighbours(x,y,'#')>=1 && count_neighbours(x,y,'|')>=1
                char = '#' 
            else
                char = '.' 
            end
        end
        new_field[[x,y]] = char
    end
    field = new_field
end
