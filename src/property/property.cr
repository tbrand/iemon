module Iemon
  class Property(T)
    @shm_addr     : Pointer(UInt8) = Pointer(UInt8).null
    @shm_id       : Int32 = -1
    @attached_pid : Int32 = -1
    @detached_pid : Int32 = -1
    @cleaned      : Bool = false
    @value_set    : Bool = false

    def initialize
      setup_shm
    end

    def initialize(value : T)
      setup_shm
      set_value(value)
    end

    def check_type(value : T)
      if !Iemon::Primitives::STRUCT.includes?(T) &&
         !Iemon::Primitives::CLASS.includes?(T) &&
         !value.is_a?(Iemon::Object)
        error_message =
          "#{T.name} can not be assigned. " +
          "Only primitive types or Iemon::Object are supported."

        raise NotSupportedType.new(error_message)
      end 
    end

    def setup_shm
      @shm_id = LibShm.shmget(
        LibShm::IPC_PRIVATE, sizeof(T),
        LibShm::IPC_CREATE | LibShm::IPC_EXCL
      ) if @shm_id < 0
    end

    def value : T
      attach unless attached?
      v = raw_value
      detach
      v
    end

    def raw_value : T
      raise NotAttached.new("#{self.class.name} is not attached.") unless attached?
      raise ValueNotSet.new("Value is not set for #{self.class.name}") unless @value_set
      @shm_addr.as(T*).value
    end

    def set_value(value : T)
      check_type(value)

      attach unless attached?
      set_raw_value(value)
      @value_set = true
      detach
    end

    def set_raw_value(value : T)
      @shm_addr.as(T*).value = value      
    end

    def attached? : Bool
      @attached_pid == Process.pid
    end

    def attach
      raise AlreadyCleaned.new("failed to attach the property. " +
                               "(property is already cleaned)") if @cleaned

      @shm_addr = LibShm.shmat(@shm_id, nil, 0)

      @attached_pid = Process.pid
      @detached_pid = -1
    end

    def detached? : Bool
      @detached_pid == Process.pid
    end

    def detach
      raise AlreadyCleaned.new("failed to detach the property. " +
                              "(property is already cleaned)") if @cleaned

      res = LibShm.shmdt(@shm_addr)
      raise LibShmException.new("LibShm#shmdt returns error code: #{res}.") if res != 0

      @attached_pid = -1
      @detached_pid = Process.pid
    end

    def clean(recursive : Bool = false)
      raise AlreadyCleaned.new("failed to clean the property. " +
                               "(property is already cleaned)") if @cleaned

      value.clean if recursive && value.is_a?(Iemon::Object)

      @cleaned = true
      res = LibShm.shmctl(@shm_id, 0, nil)
      raise LibShmException.new("LibShm#shmctl returns error code: #{res}.") if res != 0
    end

    def cleaned? : Bool
      @cleaned
    end
  end
end
