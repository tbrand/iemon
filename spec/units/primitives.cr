macro define_primitive_class
  {% for prim in Iemon::Primitives::STRUCT %}
    class P_{{ prim.id }} < Iemon::Object
      assigns(prim: {{ prim.id }})
    end
  {% end %}

  {% for prim in Iemon::Primitives::CLASS %}
    class P_{{ prim.id }} < Iemon::Object
      assigns(prim: {{ prim.id }})
    end
  {% end %}
end

macro define_primitive_specs
  describe "Primitives" do
    {% for prim in Iemon::Primitives::STRUCT %}
      context "primitive: {{ prim.id }}" do
        it "create" do
          p = P_{{ prim.id }}.new
          p.clean
        end
      end
    {% end %}

    {% for prim in Iemon::Primitives::CLASS %}
      context "primitive: {{ prim.id }}" do
        it "create" do
          p = P_{{ prim.id }}.new
          p.clean
        end
      end
    {% end %}
  end
end

define_primitive_class
define_primitive_specs
