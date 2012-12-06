require 'spec_helper'

module Sunspot::Queue::Resque
  class SampleModel ; end

  describe Backend do
    subject(:backend){ described_class.new(configuration) }
    let(:configuration){ double("Configuration") }

    describe "#index" do
      let(:index_job){ double("Resque Job") }

      before do
        configuration.stub(:resque_index_job).and_return index_job
      end

      it "enqueues a job in Resque using the configuration's resque_index_job" do
        ::Resque::should_receive(:enqueue).with(index_job, SampleModel, 3)
        backend.index(SampleModel, 3)
      end
    end

    describe "#remove" do
      let(:removal_job){ double("Resque Job") }

      before do
        configuration.stub(:resque_index_job).and_return removal_job
      end

      it "enqueues a job in Resque using the configuration's resque_index_job" do
        ::Resque::should_receive(:enqueue).with(removal_job, SampleModel, 7)
        backend.index(SampleModel, 7)
      end
    end

  end
end