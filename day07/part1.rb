lines = File.readlines('input')
forward = Hash.new { |h, k| h[k] = [] }
reverse = Hash.new { |h, k| h[k] = [] }
lines.each do |_line|
  _words = _line.split(' ')
  forward[_words[1]] << _words[7]
  reverse[_words[7]] << _words[1]
end

_next = []
forward.keys.each do |_root|
  _root = reverse[_root].first while reverse[_root].count > 0
  _next << _root unless _next.include?(_root)
end

_order = []
while _next.count>0
  _ready = _next.select { |_root| (reverse[_root] - _order).count==0 }
  _expand = _ready.sort.first
  _order << _expand
  _next.delete(_expand)
  _next += forward[_expand]
end

puts _order.join('')