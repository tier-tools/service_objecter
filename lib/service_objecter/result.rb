module ServiceObjecter
  class Result
    def initialize(success, value = nil, store = nil)
      @success, @value, @store = success, value, store
    end

    def push(success, value = nil)
      @success = success
      store.merge!(value) if value.is_a?(Hash)
      @value = value
      self.class.new(@success, @value, store)
    end

    def success?
      @success
    end

    def failure?
      !@success
    end

    def value
      @value
    end

    def [](val)
      @store[val]
    end

    def store
      @store ||= Hash.new
    end

    def as_json(_ = nil)
      {
        success: @success,
        value: value
      }
    end
  end
end
