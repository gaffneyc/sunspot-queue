require "spec_helper"
require "sunspot/queue/inline"

describe Sunspot::Queue::Inline::Backend, :backend => :inline do
  it "indexes the class inline" do
    expect do
      Person.create(:name => "Steven Seagal")
      commit
    end.to change { Person.search.hits.size }.by(1)
  end

  it "removes the class inline" do
    chuck = Person.create(:name => "Chuck Norris")
    commit

    expect do
      chuck.destroy
      commit
    end.to change { Person.search.hits.size }.by(-1)
  end
end
