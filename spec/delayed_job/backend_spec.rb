require "spec_helper"

describe Sunspot::Queue::DelayedJob::Backend do

  # Mock DelayedJobJob 
  class CustomDelayedJobJob < Struct.new(:klass, :id)
    def perform
    end
  end

  subject(:backend) { described_class.new(configuration) }

  let(:configuration) { ::Sunspot::Queue::Configuration.new }

  describe "#index" do
    it "uses the index job set in the global configuration" do
      configuration.index_job = CustomDelayedJobJob

      Delayed::Job.should_receive(:enqueue) do |args|
        args.first.is_a? CustomDelayedJobJob
      end

      backend.index(Person, 3)
    end

    it "uses the default index job if one is not configured" do
      Delayed::Job.should_receive(:enqueue) do |args|
        args.first.is_a? Sunspot::Queue::DelayedJob::IndexJob
      end
      
      backend.index(Person, 12)
    end
  end

  describe "#remove" do
    it "uses the removal job set in the global configuration" do
      configuration.removal_job = CustomDelayedJobJob

      Delayed::Job.should_receive(:enqueue) do |args|
        args.first.is_a? CustomDelayedJobJob
      end

      backend.remove(Person, 3)
    end

    it "uses the default index job if one is not configured" do
      Delayed::Job.should_receive(:enqueue) do |args|
        args.first.is_a? Sunspot::Queue::DelayedJob::RemovalJob
      end

      backend.remove(Person, 12)
    end
  end
end
