@width = 0
@height = 0
@walls = {}
@players = {}

def read_state(filename)
  lines = File.readlines(filename)
  lines.each(&:chomp!)

  @width = lines[0].length
  @height = lines.length
  @walls = {}
  @players = {}

  lines.each_with_index do |line, y|
    line.split('').each_with_index do |c, x|
      case c
      when '#'
        @walls[[x, y]] = true
      when 'E', 'G'
        @players[[x, y]] = { x: x, y: y, type: c, health: 200, attack: 3 }
      end
    end
  end
end

def print_attack_state
  (0...@height).each do |y|
    notes = []
    (0...@width).each do |x|
      if @players[[x, y]]
        player = @players[[x, y]]
        print player[:type]
        notes << "#{player[:type]}(#{player[:health]})"
      else
        print @walls[[x, y]] ? '#' : '.'
      end
    end
    puts '   ' + notes.join(', ')
  end
  puts
end

def reorder_players
  @players = @players.map do |_, player|
    [[player[:x], player[:y]], player]
  end.sort_by { |_, v| v[:y] * 100 + v[:x] }.to_h
end

def player_move(x, y)
  player = @players[[x, y]]
  type = other_type(player[:type])
  return [x, y] if neighbours_type(player[:x], player[:y], type)

  nx, ny = find_closest_neighbour_type(player[:x], player[:y], type)
  return [x, y] if nx.nil?

  px, py = find_closest_neighbour_pos(nx, ny, player[:x], player[:y])
  @players.delete([x, y])
  player[:x] = px
  player[:y] = py
  @players[[px, py]] = player
  [px, py]
end

def other_type(type)
  type == 'E' ? 'G' : 'E'
end

def select_victim(fx, fy)
  type = other_type(@players[[fx, fy]][:type])
  [[-1, 0], [1, 0], [0, -1], [0, 1]].map do |coords|
    x = fx + coords[0]
    y = fy + coords[1]
    [x, y]
  end.select do |x, y|
    @players[[x, y]] && @players[[x, y]][:type] == type
  end.min_by { |x, y| @players[[x, y]][:health] * 10_000 + y * 100 + x }
end

def player_attack(x, y)
  key = select_victim(x, y)
  return if key.nil?

  player = @players[[x, y]]
  victim = @players[key]
  victim[:health] -= player[:attack]
  @players.delete(key) if victim[:health] <= 0
end

def victims_left(type)
  type = other_type(type)
  @players.keys.select do |x, y|
    @players[[x, y]][:type] == type
  end.count
end

def do_turn
  @players.dup.each do |coords, player|
    next if @players[coords] != player

    x, y = coords
    return false if victims_left(@players[[x, y]][:type]) == 0

    x, y = player_move(x, y)
    player_attack(x, y)
  end
  reorder_players
  true
end

def neighbours_type(fx, fy, type)
  [[-1, 0], [1, 0], [0, -1], [0, 1]].reduce(false) do |result, coords|
    x = fx + coords[0]
    y = fy + coords[1]
    result ||= (@players[[x, y]] && @players[[x, y]][:type] == type)
  end
end

def find_closest_neighbour_type(x, y, type)
  prev_fronteer = {}
  fronteer = { [x, y] => true }

  loop do
    result = fronteer.keys.select { |x, y| neighbours_type(x, y, type) }.min_by { |x, y| y * 100 + x }
    return result unless result.nil?

    new_fronteer = {}
    fronteer.keys.each do |fx, fy|
      [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |dx, dy|
        x = fx + dx
        y = fy + dy
        new_fronteer[[x, y]] = true unless fronteer[[x, y]] || prev_fronteer[[x, y]] || @walls[[x, y]] || @players[[x, y]]
      end
    end
    return nil if new_fronteer.empty?

    prev_fronteer = fronteer
    fronteer = new_fronteer
  end
end

def neighbours_pos(fx, fy, px, py)
  [[-1, 0], [1, 0], [0, -1], [0, 1]].reduce(false) do |result, coords|
    x = fx + coords[0]
    y = fy + coords[1]
    result ||= (@players[[x, y]] && @players[[x, y]][:x] == px && @players[[x, y]][:y] == py)
  end
end

def find_closest_neighbour_pos(x, y, px, py)
  prev_fronteer = {}
  fronteer = { [x, y] => true }

  loop do
    result = fronteer.keys.select { |x, y| neighbours_pos(x, y, px, py) }.min_by { |x, y| y * 100 + x }
    return result unless result.nil?

    new_fronteer = {}
    fronteer.keys.each do |fx, fy|
      [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |dx, dy|
        x = fx + dx
        y = fy + dy
        new_fronteer[[x, y]] = true unless fronteer[[x, y]] || prev_fronteer[[x, y]] || @walls[[x, y]] || @players[[x, y]]
      end
    end
    return nil if new_fronteer.empty?

    prev_fronteer = fronteer
    fronteer = new_fronteer
  end
end

def game
  i = 0
  loop do
    break unless do_turn

    i += 1
  end
  sum = @players.sum { |_, player| player[:health] }
  i * sum
end

def add_attack_bonus(bonus)
  @players.each do |_, player|
    player[:attack] += bonus if player[:type] == 'E'
  end
end

bonus = 0
score = 0
loop do
  read_state('input')
  elf_count = victims_left('G')
  add_attack_bonus(bonus)
  score = game
  bonus += 1
  break if elf_count == victims_left('G')
end

puts score
