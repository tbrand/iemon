require "../src/iemon"

class MyObj < Iemon::Object
  assigns(x: Int32)
end

my_obj = MyObj.new(x: 1)

fork do
  my_obj.x = 2
end

sleep 0.1

puts my_obj.x

my_obj.clean
