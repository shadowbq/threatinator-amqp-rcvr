require 'spec_helper'
require 'threatinator/amqp/rcvr/cli'

describe Threatinator::Amqp::Rcvr::CLI  do
  let(:args) { [] }

  describe "--help" do
    before :each do
      args << '--help'
      @exception = nil
      @exit_code = nil
    end

    it "should have an exit code of 0" do
      ARGV=args
      expect { output = temp_stdout {::Threatinator::Amqp::Rcvr::CLI.invoke } }.to raise_error SystemExit
    end

    it "should print usage information" do
      # http://stackoverflow.com/questions/1480537/how-can-i-validate-exits-and-aborts-in-rspec
      # expect (output).to match(/^NAME/)
    end

  end
end  
