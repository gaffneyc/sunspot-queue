require 'spec_helper'

describe Sunspot::Queue::Configuration do
  subject(:configuration){ described_class.new }

  describe "#resque_index_job" do
    it "defaults to ::Sunspot::Queue::Resque::IndexJob" do
      configuration.resque_index_job.should eq(::Sunspot::Queue::Resque::IndexJob)
    end

    it "can be set to a custom job" do
      expect {
        configuration.resque_index_job = "MyCustomIndexJob"
      }.to change(configuration, :resque_index_job).to("MyCustomIndexJob")
    end
  end

  describe "#sidekiq_index_job" do
    it "defaults to ::Sunspot::Queue::Sidekiq::IndexJob" do
      configuration.sidekiq_index_job.should eq(::Sunspot::Queue::Sidekiq::IndexJob)
    end

    it "can be set to a custom job" do
      expect {
        configuration.sidekiq_index_job = "MyCustomIndexJob"
      }.to change(configuration, :sidekiq_index_job).to("MyCustomIndexJob")
    end
  end
end