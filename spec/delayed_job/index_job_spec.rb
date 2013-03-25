require "spec_helper"

describe Sunspot::Queue::DelayedJob::IndexJob do
  context "ActiveRecord" do

    it "indexes an ActiveRecord model" do
      person = Person.create(:name => "The Grandson") 
      job = Sunspot::Queue::DelayedJob::IndexJob.new(Person, person.id)

      # This will queue a job but we'll just ignore it to isolate the job
      expect do
        job.perform
        commit
      end.to change { Person.search.hits.size }.by(1)

      results = Person.search { fulltext "grandson" }.results
      results.first.should == person
    end

    it "raises an error if the record could not be found" do
      job = Sunspot::Queue::DelayedJob::IndexJob.new(Person, 404)

      expect do
        job.perform
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "maintains the existing proxy if there was an error" do
      job = Sunspot::Queue::DelayedJob::IndexJob.new(Person, 404)

      expect do
        job.perform rescue nil
      end.to_not change { Sunspot.session }
    end

    it "does not commit changes to the index" do
      person = Person.create(:name => "The Grandson")
      job = Sunspot::Queue::DelayedJob::IndexJob.new(Person, person.id)

      expect do
        job.perform
      end.to_not change { Person.search.hits.size }

      expect do
        commit
      end.to change { Person.search.hits.size }
    end
  end
end
