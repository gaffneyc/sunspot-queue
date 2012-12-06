require 'spec_helper'

describe Sunspot::Queue do

  describe "#configuration" do
    it "returns a default configuration" do
      config = Sunspot::Queue.configuration
      config.should be_kind_of(Sunspot::Queue::Configuration)
    end

    it "returns the same same configuration when requested multiple times" do
      config = Sunspot::Queue.configuration
      Sunspot::Queue.configuration.should be(config)
      Sunspot::Queue.configuration.should be(config)
    end
  end

  describe "#configure(&blk)" do
    it "yields the configuration to a block" do
      config = Sunspot::Queue.configuration
      expect { |blk|
        Sunspot::Queue.configure(&blk)
      }.to yield_with_args(config)
    end
  end

  describe "defaults" do
  end

end