require 'spec_helper'

describe Threatinator::Amqp::Rcvr do
  it 'has a version number' do
    expect(Threatinator::Amqp::Rcvr::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
