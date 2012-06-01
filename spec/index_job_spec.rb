require "spec_helper"

describe Sunspot::Queue::IndexJob do
  context "ActiveRecord" do
    it "indexes an ActiveRecord model" do
      # This will queue a job but we'll just ignore it to isolate the job
      person = Person.create(:name => "The Grandson")

      expect do
        Sunspot::Queue::IndexJob.perform(Person, person.id)
        commit
      end.to change { Person.search.hits.size }.by(1)

      results = Person.search { fulltext "grandson" }.results
      results.first.should == person
    end

    it "raises an error if the record could not be found" do
      expect do
        Sunspot::Queue::IndexJob.perform(Person, 404)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "maintains the existing proxy if there was an error" do
      expect do
        Sunspot::Queue::IndexJob.perform(Person, 404) rescue nil
      end.to_not change { Sunspot.session }
    end

    it "does not commit changes to the index" do
      person = Person.create(:name => "The Grandson")

      expect do
        Sunspot::Queue::IndexJob.perform(Person, person.id)
      end.to_not change { Person.search.hits.size }

      expect do
        commit
      end.to change { Person.search.hits.size }
    end
  end
end
