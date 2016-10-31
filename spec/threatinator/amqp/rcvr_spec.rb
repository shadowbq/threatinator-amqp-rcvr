require 'spec_helper'

describe Threatinator::Amqp::Rcvr do
  it 'has a version number' do
    expect(Threatinator::Amqp::Rcvr::VERSION).not_to be nil
  end
end
