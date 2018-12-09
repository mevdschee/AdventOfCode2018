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
assert_equal('[0*]', DoubleLinkedCircularList.new.insert(0).to_s)
assert_equal('[]', DoubleLinkedCircularList.new.insert(0).delete.to_s)
assert_equal('[]', DoubleLinkedCircularList.new.insert(0).delete.delete.to_s)
assert_equal('[0,1,2*]', DoubleLinkedCircularList.new.insert(0).insert(1).insert(2).to_s)
assert_equal('[0,1*]', DoubleLinkedCircularList.new.insert(0).insert(1).insert(2).delete.to_s)
assert_equal('[0*]', DoubleLinkedCircularList.new.insert(0).insert(1).insert(2).delete.delete.step(-1).to_s)
assert_equal('[0*]', DoubleLinkedCircularList.new.insert(0).insert(1).insert(2).delete.delete.step(1).to_s)
assert_equal('[0,1*,2]', DoubleLinkedCircularList.new.insert(0).insert(1).insert(2).step(-6).step(5).to_s)
assert_equal('[0,1,2*]', DoubleLinkedCircularList.new.insert(0).insert(2).step(-1).insert(1).step(1).to_s)
assert_equal(nil, DoubleLinkedCircularList.new.read)
assert_equal(0, DoubleLinkedCircularList.new.insert(0).read)
assert_equal(1, DoubleLinkedCircularList.new.insert(0).insert(1).read)
assert_equal(1, DoubleLinkedCircularList.new.insert(0).insert(1).insert(2).step(-1).read)
assert_equal('[1,2*]', DoubleLinkedCircularList.new.insert(0).insert(1).insert(2).step(-2).delete.to_s)
