require 'spec_helper'

module Sunspot::Queue::Sidekiq
  class SampleModel ; end

  describe Backend do
    subject(:backend){ described_class.new(configuration) }
    let(:configuration){ double("Configuration") }

    describe "#index" do
      let(:index_job){ double("Sidekiq Job") }

      before do
        configuration.stub(:sidekiq_index_job).and_return index_job
      end

      it "enqueues a job in Resque using the configuration's sidekiq_index_job" do
        index_job.should_receive(:perform_async).with(SampleModel, 9)
        backend.index(SampleModel, 9)
      end
    end

    describe "#remove" do
      let(:removal_job){ double("Sidekiq Job") }

      before do
        configuration.stub(:sidekiq_index_job).and_return removal_job
      end

      it "enqueues a job in Resque using the configuration's sidekiq_removal_job" do
        removal_job.should_receive(:perform_async).with(SampleModel, 11)
        backend.index(SampleModel, 11)
      end
    end
  end

end
