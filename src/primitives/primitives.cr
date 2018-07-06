module Iemon
  module Primitives
    STRUCT = [
      Bool, Char, Symbol,
      Int8, Int16, Int32, Int64, Int128,
      UInt8, UInt16, UInt32, UInt64, UInt128,
      Float32, Float64
    ]

    CLASS = [
      String,
    ]

    macro define_struct
      {% for s in STRUCT %}
        struct {{ s.id }}
          #
          # Override or define some method if it's needed
          #
          def clean; end
        end
      {% end %}
    end

    macro define_class
      {% for c in CLASS %}
        class {{ c.id }}
          #
          # Override or define some method if it's needed
          #
          def clean; end
        end
      {% end %}
    end
  end
end
