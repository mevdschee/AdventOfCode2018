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
_workers = {}
_worker_count = 5
_seconds_added = 61
_time=0
while _next.count>0 || _workers.keys.count>0
  _worker_count.times do
    if _workers.keys.count < _worker_count
      _ready = (_next - _workers.keys).select { |_root| (reverse[_root] - _order).count==0 }
      if _ready.count>0
        _expand = _ready.sort.first
        _workers[_expand] = _seconds_added+(_expand.ord-'A'.ord)
      end
    end
  end
  _workers.keys.each { |_i| _workers[_i]-=1 }
  _ready = _workers.select { |_k,_v| _v==0 }.keys
  _ready.each do |_expand|
    _order << _expand
    _next += forward[_expand]
    _next.delete(_expand)
    _workers.delete(_expand)  
    _next.uniq!
  end
  _time+=1
end

puts _time