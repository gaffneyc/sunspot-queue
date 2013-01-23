require "spec_helper"

describe Sunspot::Queue::Configuration do
  subject(:configuration) { described_class.new }

  describe "#index_job" do
    it "defaults to nil" do
      configuration.index_job.should be_nil
    end

    it "can be set to a custom job" do
      expect {
        configuration.index_job = "CustomIndexJob"
      }.to change(configuration, :index_job).to("CustomIndexJob")
    end
  end

  describe "#removal_job" do
    it "defaults to nil" do
      configuration.removal_job.should be_nil
    end

    it "can be set to a custom job" do
      expect do
        configuration.removal_job = "CustomRemovalJob"
      end.to change(configuration, :removal_job).to("CustomRemovalJob")
    end
  end
end
