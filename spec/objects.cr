class X < Iemon::Object
  assigns(x: Int32)
end

class Y
  def clean; end
end

class Z < Iemon::Object
  assigns(x: X)
end
