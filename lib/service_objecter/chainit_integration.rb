require 'forwardable'
module ServiceObjecter
  module ChainitIntegration
    extend(Forwardable)

    def self.prepended(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def call(*args)
        service = new
        service.send :__set_chain__
        service.call(*args)
      end
    end

    def_delegators :@__chain__, :chain, :skip_next, :on_error, :result
    alias run chain

    private

    def __set_chain__
      @__chain__ = ChainIt.new
    end

    def __get_chain__
      @__chain__
    end
  end
end
