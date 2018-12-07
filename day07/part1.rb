lines = File.readlines('input')
forward = Hash.new { |h, k| h[k] = [] }
reverse = Hash.new { |h, k| h[k] = [] }
lines.each do |_line|
  _words = _line.split(' ')
  forward[_words[1]] << _words[7]
  reverse[_words[7]] << _words[1]
end

forward.map { |k, v| [k, v.sort] }

def find_root(reverse)
  _root = reverse.keys.first
  _root = reverse[_root].first while reverse[_root].count > 0
  _root
end

def find_order(_order, _root, forward, reverse)
  required = reverse[_root] - _order
  if required.count==0
    _order << _root
    forward[_root].each do |_curr|
      find_order(_order, _curr, forward, reverse)
    end
  end
end

_order = []
find_order(_order, find_root(reverse), forward, reverse)
puts _order.join('')