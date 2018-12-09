require 'test/unit'

def capture_stdout
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end

capture_stdout { load 'part1.rb' }

extend Test::Unit::Assertions

assert_equal('[]', DoubleLinkedCircularList.new.to_s)
assert_equal('[0]', DoubleLinkedCircularList.new.append(0).to_s)
assert_equal('[]', DoubleLinkedCircularList.new.append(0).remove.to_s)
assert_equal('[]', DoubleLinkedCircularList.new.append(0).remove.remove.to_s)
assert_equal('[0,1,2]', DoubleLinkedCircularList.new.append(0).append(1).append(2).to_s)
assert_equal('[0,1]', DoubleLinkedCircularList.new.append(0).append(1).append(2).remove.to_s)
assert_equal('[0]', DoubleLinkedCircularList.new.append(0).append(1).append(2).remove.remove.rotate(-1).to_s)
assert_equal('[0]', DoubleLinkedCircularList.new.append(0).append(1).append(2).remove.remove.rotate(1).to_s)
assert_equal('[2,0,1]', DoubleLinkedCircularList.new.append(0).append(1).append(2).rotate(-6).rotate(5).to_s)
assert_equal('[0,1,2]', DoubleLinkedCircularList.new.append(0).append(2).rotate(-1).append(1).rotate(1).to_s)
assert_equal('[0,]', DoubleLinkedCircularList.new.append(0).append(nil).to_s)
assert_equal(nil, DoubleLinkedCircularList.new.read)
assert_equal(nil, DoubleLinkedCircularList.new.append(0).append(nil).read)
assert_equal(0, DoubleLinkedCircularList.new.append(0).read)
assert_equal(1, DoubleLinkedCircularList.new.append(0).append(1).read)
assert_equal(1, DoubleLinkedCircularList.new.append(0).append(1).append(2).rotate(-1).read)
assert_equal('[1,2]', DoubleLinkedCircularList.new.append(0).append(1).append(2).rotate(-2).remove.to_s)
assert_equal(0, DoubleLinkedCircularList.new.length)
assert_equal(0, DoubleLinkedCircularList.new.remove.length)
assert_equal(1, DoubleLinkedCircularList.new.append(0).length)
assert_equal(2, DoubleLinkedCircularList.new.append(0).append(1).length)
assert_equal(1, DoubleLinkedCircularList.new.append(0).append(1).append(2).remove.remove.length)
