require 'service_objecter/result'
require 'service_objecter/chainit_integration'

module ServiceObjecter
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.include(ChainitIntegration) if defined?(ChainIt)
  end

  module ClassMethods
    def call(*args)
      new.call(*args)
    end
  end

  def call
    raise NotImplementedError
  end

  private

  def success(value = nil)
    result.push(true, value)
  end

  def failed(value = nil)
    result.push(false, value)
  end

  def crashed(error, value = nil)
    log(error)
    failed value || error
  end

  def log(data)
    return unless defined?(Rails)
    Rails.logger.error data
  end

  def result
    @result ||= Result.new(true)
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
    result = nil
    ActiveRecord::Base.transaction(requires_new: true) do
      result = yield
      raise ActiveRecord::Rollback if result.failure?
    end
    result
  end
end

require 'service_objecter/version'
