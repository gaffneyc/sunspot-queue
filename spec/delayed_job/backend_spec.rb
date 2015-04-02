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

    it "performs the job in real time in case of failure queueing the job" do
      configuration.force_index_on_failure = true
      Delayed::Job.should_receive(:enqueue) { raise 'some error' }
      Sunspot::Queue::DelayedJob::IndexJob.any_instance.should_receive(:perform)

      backend.index(Person, 12)
    end

    it "raises the error witout performing the job in real time in case of failure queueing the job" do
      configuration.force_index_on_failure = false
      Delayed::Job.should_receive(:enqueue) { raise 'some error' }
      Sunspot::Queue::DelayedJob::IndexJob.any_instance.should_not_receive(:perform)

      expect { backend.index(Person, 12) }.to raise_error('some error')
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
