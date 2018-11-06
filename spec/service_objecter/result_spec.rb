require 'spec_helper'

RSpec.describe ServiceObjecter::Result do
  subject { described_class.new(true) }

  it 'add and returns store value' do
    subject.push(true, value: 1)
    expect(subject[:value]).to eq(1)
  end

  it 'returns success? true if success' do
    expect(subject.success?).to be true
  end

  it 'returns failure? true if not success' do
    subject.push(false)
    expect(subject.failure?).to be true
  end

  it 'returns value' do
    result = described_class.new(true, 1)
    expect(result.value).to eq 1
  end
end
