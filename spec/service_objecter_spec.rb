require 'spec_helper'

RSpec.describe ServiceObjecter do
  let(:klass) { Class.new }

  before do
    klass.include subject
  end

  describe '#call' do
    it 'runs call instalnce' do
      expect(klass).to receive(:call)
      klass.call
    end
  end

  describe '#success' do
    it 'returns success result object' do
      expect(klass.new.send(:success)).to be_instance_of(klass::Result)
        .and have_attributes(success?: true)
    end

    let(:value) { :some_value }

    it 'returns result with value' do
      expect(klass.new.send(:success, value)).to have_attributes(value: value)
    end
  end

  describe '#failed' do
    it 'returns failed result object' do
      expect(klass.new.send(:failed)).to be_instance_of(klass::Result)
        .and have_attributes(success?: false)
    end

    let(:value) { :some_value }

    it 'returns result with value' do
      expect(klass.new.send(:success, value)).to have_attributes(value: value)
    end
  end

  it 'has a version number' do
    expect(ServiceObjecter::VERSION).to eq '1.0.0'
  end

  context '#with_transaction' do
    let(:active_record) { ActiveRecord = Module.new }
    let(:rollback) { ActiveRecord::Rollback = Exception.new }
    let(:active_record_base) do
      ActiveRecord::Base = Class.new do
        def self.transaction(requires_new = nil)
          yield
        rescue ActiveRecord::Rollback
          # do nothing
        end
      end
    end

    context 'result success' do
      let(:result) { klass::Result.new(true) }
      let(:action) do
        klass.new.send :with_transaction do
          result
        end
      end

      it 'return result' do
        expect(action).to eq(result)
      end
    end

    context 'result failure' do
      let(:result) { klass::Result.new(false) }
      let(:action) do
        klass.new.send :with_transaction do
          result
        end
      end

      it 'return result' do
        expect(action).to eq(result)
      end
    end
  end
end
