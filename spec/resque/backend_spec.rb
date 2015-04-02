require "spec_helper"

describe Sunspot::Queue::Resque::Backend do

  # Mock ResqueJob
  class CustomResqueJob
    @queue = :custom_queue

    def perform(klass, id)
    end
  end

  subject(:backend) { described_class.new(configuration) }

  let(:configuration) { ::Sunspot::Queue::Configuration.new }

  describe "#index" do
    it "uses the index job set in the global configuration" do
      configuration.index_job = CustomResqueJob

      expect do
        backend.index(Person, 3)
      end.to change { ResqueSpec.queue_for(CustomResqueJob).size }.by(1)
    end

    it "uses the default index job if one is not configured" do
      expect do
        backend.index(Person, 12)
      end.to change { ResqueSpec.queue_for(Sunspot::Queue::Resque::IndexJob).size }.by(1)
    end

    it "performs the job in real time in case of failure queueing the job" do
      configuration.force_index_on_failure = true
      Resque.should_receive(:enqueue) { raise 'some error' }
      Sunspot::Queue::Resque::IndexJob.should_receive(:perform).with(Person, 12)

      backend.index(Person, 12)
    end

    it "raises the error witout performing the job in real time in case of failure queueing the job" do
      configuration.force_index_on_failure = false
      Resque.should_receive(:enqueue) { raise 'some error' }
      Sunspot::Queue::Resque::IndexJob.should_not_receive(:perform)

      expect { backend.index(Person, 12) }.to raise_error('some error')
    end
  end

  describe "#remove" do
    it "uses the removal job set in the global configuration" do
      configuration.removal_job = CustomResqueJob

      expect do
        backend.remove(Person, 3)
      end.to change { ResqueSpec.queue_for(CustomResqueJob).size }.by(1)
    end

    it "uses the default index job if one is not configured" do
      expect do
        backend.remove(Person, 12)
      end.to change { ResqueSpec.queue_for(Sunspot::Queue::Resque::RemovalJob).size }.by(1)
    end
  end
end
