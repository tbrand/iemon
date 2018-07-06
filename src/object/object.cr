module Iemon
  class Object
    #
    # Assign properties for the object.
    # ```
    # class You
    #   assigns(x: Int32, y: Int32)
    # end
    # ```
    #
    # You can access them like `property` macro.
    # ```
    # you = You.new
    # you.x = 2
    # puts you.y
    # ```
    #
    macro assigns(**props)
      assigns({{ props }})
    end

    #
    # Assign properties for the object.
    # See above comments for the details.
    #
    macro assigns(props)
      {% for n, t in props %}
        assign({{ n.id }}, {{ t.id }})
      {% end %}

      #
      # Iemon's constructor.
      # The object which inherit Iemon have to call this.
      # ```
      # class You < Iemon
      #   def initialize
      #     super
      #   end
      # end
      # ```
      #
      def initialize
        {% for n, t in props %}
          @{{ n.id }} = Iemon::Property({{ t.id }}).new
        {% end %}
      end

      #
      # Iemon's constructor with default values.
      # ```
      # class You < Iemon
      #   assigns(x: Int32, y: Int32)
      # end
      #
      # you = You.new(x: 1, y: 2)
      # ```
      #
      def initialize(
            {% for n, t in props %}
              {{ n }} : {{ t }},
            {% end %}
          )
        {% for n, t in props %}
          @{{ n.id }} = Iemon::Property({{ t.id }}).new({{ n }})
        {% end %}
      end

      #
      # A method for detach shm which attached to the object.
      # ```
      # you.detach
      # ```
      #
      # Note that this method have to be called in
      # every objects in every processes.
      # ```
      # you1 = You.new
      # you2 = You.new
      #
      # fork do
      #   you1.x = 0
      #   you2.x = 1
      #
      #   # detach on forked process
      #   you1.detach
      #   you2.detach
      # end
      #
      # # detach on main process
      # you1.detach
      # you2.detach
      # ```
      #
      def detach
        {% for n, t in props %}
          @{{ n.id }}.not_nil!.detach
        {% end %}
      end

      #
      # A method for cleaning shm
      # Call this method once on main process for each object.
      # ```
      # you1 = You.new
      # you2 = You.new
      #
      # you1.clean
      # you2.clean
      # ```
      #
      def clean(recursive : Bool = false)
        {% for n, t in props %}
          @{{ n.id }}.not_nil!.clean(recursive)
        {% end %}
      end

      def copy(other : self)
        {% for n, t in props %}
          @{{ n.id }}.not_nil!.set_value(other.{{ n.id }})
        {% end %}
      end
    end

    #
    # Assign a property.
    # The first argument is a name of the property.
    # The second argument is the type.
    # The type have to be primitive or Iemon object.
    #
    macro assign(n, t)
      @{{ n }} : Iemon::Property({{ t }})?

      def {{ n }} : {{ t }}
        unless {{ n }} = @{{ n }}
          raise "self.{{ n }} is not initialized"
        end

        {{ n }}.value
      end

      def {{ n }}=(val : {{ t }}) : {{ t }}
        unless {{ n }} = @{{ n }}
          @{{ n }} = Iemon::Property({{ t }}).new
        end

        if val.is_a?(Iemon::Object)
          #
          # Copy every properties from val
          #
          @{{ n }}.not_nil!.value.copy(val)
          #
          # Clean the served object's properties
          #
          val.clean
        else
          @{{ n }}.not_nil!.set_value(val)
        end

        @{{ n }}.not_nil!.value
      end

      #
      # To access raw Iemon::Property(T)
      # ```
      # prop = you.__x_prop
      # ```
      #
      def __{{ n }}_prop : Iemon::Property({{ t }})?
        @{{ n }}
      end
    end
  end
end
