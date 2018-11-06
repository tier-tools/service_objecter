require 'forwardable'

module ServiceObjecter
  module ChainitIntegration
    extend(Forwardable)

    def_delegators :__get_chain__, :chain, :skip_next, :on_error, :result
    alias run chain

    def __set_chain__
      @__chain__ = ChainIt.new
      @__chain__.chain { ServiceObjecter::Result.new(true) }
      @__chain__
    end

    def __get_chain__
      __set_chain__ unless @__chain__
      @__chain__
    end
  end
end
