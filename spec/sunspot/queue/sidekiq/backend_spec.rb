require "spec_helper"

describe Sunspot::Queue::Sidekiq::Backend do

  # Mock SidekiqJob
  class CustomSidekiqJob
    include ::Sidekiq::Worker

    def perform(klass, id)
    end
  end

  subject(:backend) { described_class.new(configuration) }

  let(:configuration) { ::Sunspot::Queue::Configuration.new }

  describe "#index" do
    it "uses the index job set in the global configuration" do
      configuration.index_job = CustomSidekiqJob

      expect do
        backend.index(Person, 9)
      end.to change { CustomSidekiqJob.jobs.size }.by(1)
    end

    it "uses the default index job if one is not configured" do
      expect do
        backend.index(Person, 11)
      end.to change { ::Sunspot::Queue::Sidekiq::IndexJob.jobs.size }.by(1)
    end
  end

  describe "#remove" do
    it "uses the removal job set in the global configuration" do
      configuration.removal_job = CustomSidekiqJob

      expect do
        backend.remove(Person, 11)
      end.to change { CustomSidekiqJob.jobs.size }.by(1)
    end

    it "uses the default removal job if one is not configured" do
      expect do
        backend.remove(Person, 11)
      end.to change { ::Sunspot::Queue::Sidekiq::RemovalJob.jobs.size }.by(1)
    end
  end
end
