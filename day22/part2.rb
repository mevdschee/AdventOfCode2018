lines = File.readlines('input')
@depth = lines[0].strip.split(': ')[1].to_i
@tx, @ty = lines[1].strip.split(': ')[1].split(',').map(&:to_i)

@map = {}
@visited = Hash.new(false)

def make_map(xm, ym)
  erosion = {}
  (0..@ty + ym).each do |y|
    (0..@tx + xm).each do |x|
      geo = if [x, y] == [0, 0] || [x, y] == [@tx, @ty]
              0
            elsif y == 0
              x * 16_807
            elsif x == 0
              y * 48_271
            else
              erosion[[x - 1, y]] * erosion[[x, y - 1]]
            end
      ero = (geo + @depth) % 20_183
      ch = if [x, y] == [0, 0]
             'M'
           elsif [x, y] == [@tx, @ty]
             'T'
           else
             case ero % 3
             when 0
               '.'
             when 1
               '='
             when 2
               '|'
             end
            end
      # print ch
      erosion[[x, y]] = ero
      @map[[x, y]] = ero % 3
    end
    # puts
  end
end

def compatible(x, y, gear)
  risk = @map[[x, y]]
  fail = ((risk == 0 && gear == 'neither') || (risk == 1 && gear == 'torch') || (risk == 2 && gear == 'climbing'))
  !fail
end

make_map(100, 100)
frontiers = [[0, 0, 'torch', 0, '']]
distance = 0
@visited[[0, 0, 'torch']] = true
done = false
until @visited[[@tx, @ty, 'torch']]
  new_frontiers = []
  frontiers.each do |x, y, gear, wait|
    if wait > 0
      new_frontiers << [x, y, gear, wait - 1]
      next
    end

    [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dx, dy|
      nx = x + dx
      ny = y + dy
      next if @map[[nx, ny]].nil?

      if compatible(nx, ny, gear) && !@visited[[nx, ny, gear]]
        new_frontiers << [nx, ny, gear, 0]
      end
    end

    %w[torch climbing neither].each do |new_gear|
      if gear != new_gear && compatible(x, y, new_gear) && !@visited[[x, y, new_gear]]
        new_frontiers << [x, y, new_gear, 6]
      end
    end
  end

  frontiers = new_frontiers.uniq

  frontiers.each do |x, y, gear, wait|
    @visited[[x, y, gear]] = true if wait == 0
  end

  distance += 1
end

puts distance
