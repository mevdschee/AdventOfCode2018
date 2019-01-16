def register_string_connections(str, frontiers, connections)
  new_frontiers = []
  frontiers.each do |x, y|
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
    new_frontiers << [x, y]
  end
  new_frontiers.uniq
end

def register_array_connections(arr, frontiers, connections)
  arr.each do |e|
    frontiers = if e.is_a?(Array)
                  register_node_connections(e, frontiers, connections)
                else
                  register_string_connections(e, frontiers, connections)
                end
  end
  frontiers
end

def register_node_connections(nodes, frontiers, connections)
  new_frontiers = []
  nodes.each do |node|
    new_frontiers += register_array_connections(node, frontiers, connections)
  end
  new_frontiers.uniq
end

# def connections_to_s(connections)
#   min_x = connections.keys.map { |v| [v[0], v[2]].min }.min
#   min_y = connections.keys.map { |v| [v[1], v[3]].min }.min
#   max_x = connections.keys.map { |v| [v[0], v[2]].max }.max
#   max_y = connections.keys.map { |v| [v[1], v[3]].max }.max
#   s = ''
#   (min_y..max_y).each do |y|
#     (min_x..max_x).each do |x|
#       key1 = [x, y]
#       key2 = [x, y - 1]
#       s += (connections[key1 + key2] ? '#-' : '##')
#     end
#     s += "#\n"
#     (min_x..max_x).each do |x|
#       key1 = [x, y]
#       key2 = [x - 1, y]
#       s += (connections[key1 + key2] ? '|' : '#')
#       s += (key1 == [0, 0] ? 'X' : '.')
#     end
#     s += "#\n"
#   end
#   (min_x..max_x).each do |_x|
#     s += '##'
#   end
#   s += "#\n"
#   s
# end

def calculate_distances(connections)
  frontiers = [[0, 0]]
  distances = {}
  distance = 0
  until frontiers.empty?
    new_frontiers = []
    frontiers.each do |x, y|
      key1 = [x, y]
      next unless distances[key1].nil?

      distances[key1] = distance
      [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |dx, dy|
        key2 = [x + dx, y + dy]
        new_frontiers << key2 if connections[key1 + key2]
      end
    end
    frontiers = new_frontiers.uniq
    distance += 1
  end
  distances
end

input = IO.read('input').chomp[1...-1]
# convert from "^ENWWW(NEEE|SSE(EE|N))$" to: "[['ENWWW',[['NEEE'],['SSE',[['EE'],['N']],'']],'']]"
nodes = eval('[[\'' + input.gsub('(', '\',[[\'').gsub(')', '\']],\'').gsub('|', '\'],[\'') + '\']]')
connections = Hash.new(false)
register_node_connections(nodes, [[0, 0]], connections)
# puts connections_to_s(connections)
distances = calculate_distances(connections)
p distances.values.select { |v| v >= 1000 }.count
