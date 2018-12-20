def register_string_connections(str, fronteers, connections)
  new_fronteers = []
  fronteers.each do |x, y|
    str.split('').each do |c|
      key1 = [x, y]
      case c
      when 'N'
        y -= 1
      when 'S'
        y += 1
      when 'W'
        x -= 1
      when 'E'
        x += 1
      end
      key2 = [x, y]
      connections[key1 + key2] = true
      connections[key2 + key1] = true
    end
    new_fronteers << [x, y]
  end
  new_fronteers.uniq
end

def register_array_connections(arr, fronteers, connections)
  arr.each do |e|
    fronteers = if e.is_a?(Array)
                  register_node_connections(e, fronteers, connections)
                else
                  register_string_connections(e, fronteers, connections)
                end
  end
  fronteers
end

def register_node_connections(nodes, fronteers, connections)
  new_fronteers = []
  nodes.each do |node|
    new_fronteers += register_array_connections(node, fronteers, connections)
  end
  new_fronteers.uniq
end

def connections_to_s(connections)
  min_x = connections.keys.map { |v| [v[0], v[2]].min }.min
  min_y = connections.keys.map { |v| [v[1], v[3]].min }.min
  max_x = connections.keys.map { |v| [v[0], v[2]].max }.max
  max_y = connections.keys.map { |v| [v[1], v[3]].max }.max
  s = ''
  (min_y..max_y).each do |y|
    (min_x..max_x).each do |x|
      key1 = [x, y]
      key2 = [x, y - 1]
      s += (connections[key1 + key2] ? '#-' : '##')
    end
    s += "#\n"
    (min_x..max_x).each do |x|
      key1 = [x, y]
      key2 = [x - 1, y]
      s += (connections[key1 + key2] ? '|' : '#')
      s += (key1 == [0, 0] ? 'X' : '.')
    end
    s += "#\n"
  end
  (min_x..max_x).each do |_x|
    s += '##'
  end
  s += "#\n"
  s
end

def calculate_distances(connections)
  fronteers = [[0, 0]]
  distances = {}
  distance = 0
  until fronteers.empty?
    new_fronteers = []
    fronteers.each do |x, y|
      key1 = [x, y]
      next unless distances[key1].nil?

      distances[key1] = distance
      [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |dx, dy|
        key2 = [x + dx, y + dy]
        new_fronteers << key2 if connections[key1 + key2]
      end
    end
    fronteers = new_fronteers.uniq
    distance += 1
  end
  distances
end

input = IO.read('input').chomp[1...-1]
# ^ENWWW(NEEE|SSE(EE|N))$ => [['ENWWW', [['NEEE'], ['SSE', [['EE'], ['N']], '']], '']]
nodes = eval('[[\'' + input.gsub('(', '\',[[\'').gsub(')', '\']],\'').gsub('|', '\'],[\'') + '\']]')
connections = Hash.new(false)
register_node_connections(nodes, [[0, 0]], connections)
# puts connections_to_s(connections)
distances = calculate_distances(connections)
p distances.values.max
