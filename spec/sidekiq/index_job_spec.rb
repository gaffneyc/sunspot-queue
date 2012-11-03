require "spec_helper"

describe Sunspot::Queue::Sidekiq::IndexJob do
  context "ActiveRecord" do
    let(:job) { Sunspot::Queue::Sidekiq::IndexJob.new }

    it "index an ActiveRecord model" do
      person = Person.create(:name => "Dum Dum Dugen")

      expect do
        job.perform(Person, person.id)
        commit
      end.to change { Person.search.hits.size }.by(1)
    end

    it "raises an error if the record could not be found" do
      expect do
        job.perform(Person, 404)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "maintains the existing proxy if there was an error" do
      expect do
        job.perform(Person, 404) rescue nil
      end.to_not change { Sunspot.session }
    end

    it "does not commit changes to the index" do
      person = Person.create(:name => "Kato")

      expect do
        job.perform(Person, person.id)
      end.to_not change { Person.search.hits.size }

      expect do
        commit
      end.to change { Person.search.hits.size }
    end
  end
end
