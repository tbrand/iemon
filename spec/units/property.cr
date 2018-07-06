describe Iemon::Property do
  context "value" do
    it "set and get correctly" do
      prop = Iemon::Property(Int32).new
      prop.set_value(1)
      prop.value.should eq(1)
      prop.clean
    end

    it "set value in constructor" do
      prop = Iemon::Property(Int32).new(1)
      prop.value.should eq(1)
      prop.clean
    end

    it "set_value raises NotSupportedType if it's not" do
      prop = Iemon::Property(Y).new

      expect_raises(Iemon::NotSupportedType,
                    "Y can not be assigned. "+
                    "Only primitive types or Iemon::Object are supported.") do
        prop.set_value(Y.new)
      end

      prop.clean
    end

    it "value raises NotAttached if it's not" do
      prop = Iemon::Property(Int32).new

      expect_raises(Iemon::NotAttached, "Property(Int32) is not attached") do
        prop.raw_value
      end

      prop.clean
    end

    it "value raises ValueNotSet if it's not" do
      prop = Iemon::Property(Int32).new
      prop.attach

      expect_raises(Iemon::ValueNotSet, "Value is not set for Iemon::Property(Int32)") do
        prop.raw_value
      end

      prop.clean
    end
  end

  context "attach" do
    it "correctly" do
      prop = Iemon::Property(Int32).new(1)
      prop.attach
      prop.attached?.should be_true
      prop.detach
      prop.clean
    end
  end

  context "detach" do
    it "correctly" do
      prop = Iemon::Property(Int32).new(1)
      prop.attach
      prop.detach
      prop.detached?.should be_true
      prop.clean
    end

    it "after set_value" do
      prop = Iemon::Property(Int32).new(1)
      prop.detached?.should be_true
      prop.clean
    end

    it "detached for innter Iemon::Object" do
      obj = X.new(x: 1)

      prop = Iemon::Property(X).new(obj)
      prop.value.__x_prop.not_nil!.detached?.should eq(true)
      prop.clean(true)
    end
  end

  context "clean" do
    it "correctly" do
      prop = Iemon::Property(Int32).new(1)
      prop.clean
      prop.cleaned?.should be_true
    end

    it "recursively" do
      obj = X.new(x: 1)

      prop = Iemon::Property(X).new(obj)
      prop.clean(true)

      obj.__x_prop.not_nil!.cleaned?.should eq(true)
    end

    it "not recursively" do
      obj = X.new(x: 1)

      prop = Iemon::Property(X).new(obj)
      prop.clean(false)

      obj.__x_prop.not_nil!.cleaned?.should eq(false)
      obj.__x_prop.not_nil!.clean
    end

    it "raises AlreadyCleaned if it's already cleaned" do
      prop = Iemon::Property(Int32).new(1)
      prop.clean

      expect_raises(Iemon::AlreadyCleaned, "failed to clean the property. "+
                                           "(property is already cleaned)") do
        prop.clean
      end
    end
  end
end
