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
