require 'forwardable'
module ServiceObjecter
  module ChainitIntegration
    extend(Forwardable)

    def initialize
      __set_chain__
    end

    def_delegators :@__chain__, :chain, :skip_next, :on_error, :result
    alias run chain

    private

    def __set_chain__
      @__chain__ = ChainIt.new
      @__chain__.chain { ServiceObjecter::Result.new(true) }
      @__chain__
    end

    def __get_chain__
      @__chain__
    end
  end
end
