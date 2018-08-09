module ServiceObjecter
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def call(*args)
      new.call(*args)
    end
  end

  Result = Struct.new(:success, :value) do
    def success?
      success
    end

    def failure?
      !success
    end
  end

  def call
    raise NotImplementedError
  end

  private

  def success(value = nil)
    Result.new(true, value)
  end

  def failed(value = nil)
    Result.new(false, value)
  end

  def crashed(error, value = nil)
    log(error)
    failed value || error
  end

  def log(data)
    return unless defined?(Rails)
    Rails.logger.error data
  end

  # Transactions helper
  # Simple usage
  #
  # def call
  #   with_transaction do
  #     ChainIt.new.chain { failed }.result
  #   end
  # end
  #
  # def call
  #   with_transaction do
  #     failed
  #   end
  # end

  def with_transaction
    return yield unless defined?(ActiveRecord)
    ActiveRecord::Base.transaction(requires_new: true) do
      result = yield
      raise ActiveRecord::Rollback if result.failure?
      result
    end
  end
end

require 'service_objecter/version'
