describe Iemon::Object do
  context "minimum object" do
    it "created" do
      x = X.new
      x.x = 1
      x.x.should eq(1)

      x.clean
    end

    it "created with default value" do
      x = X.new(x: 2)
      x.x.should eq(2)

      x.clean
    end

    it "change the value from forked process" do
      x = X.new(x: 3)

      fork do
        x.x = 4
      end

      sleep 0.1

      x.x.should eq(4)
      x.clean
    end

    it "change the value from master process" do
      x = X.new(x: 3)

      fork do
        sleep 0.1

        x.x.should eq(4)
      end

      x.x = 4

      sleep 0.2

      x.clean
    end

    it "change the value from forked process on another forked process" do
      x = X.new(x: 3)

      fork do
        x.x = 4
      end

      fork do
        sleep 0.1

        x.x.should eq(4)
      end

      sleep 0.2

      x.clean
    end
  end

  context "nested Iemon::Object" do
    it "created" do
      x = X.new(x: 1)
      z = Z.new(x: x)
      z.clean(true)
    end

    it "change the nested value from forked process" do
      x = X.new(x: 1)
      z = Z.new(x: x)

      fork do
        z.x.x = 2
      end

      sleep 0.1

      z.x.x.should eq(2)
      z.clean(true)
    end

    it "change the nested value from master process" do
      x = X.new(x: 1)
      z = Z.new(x: x)

      fork do
        sleep 0.1

        z.x.x.should eq(2)
      end

      z.x.x = 2

      sleep 0.2

      z.clean(true)
    end

    it "change the nested value from forked process on another forked process" do
      x = X.new(x: 1)
      z = Z.new(x: x)

      fork do
        z.x.x = 2
      end

      fork do
        sleep 0.1

        z.x.x.should eq(2)
      end

      sleep 0.2

      z.clean(true)
    end

    it "change the nested object from forked process" do
      x = X.new(x: 1)
      z = Z.new(x: x)

      fork do
        _x = X.new(x: 2)

        z.x = _x
      end

      sleep 0.1

      z.x.x.should eq(2)
      z.clean(true)
    end

    it "change the nested object from master process" do
      x = X.new(x: 1)
      z = Z.new(x: x)

      fork do
        sleep 0.1

        z.x.x.should eq(2)
      end

      _x = X.new(x: 2)
      z.x = _x

      sleep 0.2

      z.clean(true)
    end

    it "change the nested value from forked process on another forked process" do
      x = X.new(x: 1)
      z = Z.new(x: x)

      fork do
        _x = X.new(x: 2)

        z.x = _x
      end

      fork do
        sleep 0.1

        z.x.x.should eq(2)
      end

      sleep 0.2

      z.clean(true)
    end
  end
end
