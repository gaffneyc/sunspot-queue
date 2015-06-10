require "pathname"

# Fake out a minimum amount of Rails because sunspot-rails depends on it to
# run but sunspot-queue doesn't.
module Rails
  def self.root
    Pathname.new(File.expand_path("../../..", __FILE__))
  end

  def self.env
    "test"
  end

  def self.version
    ::ActiveRecord.version.to_s
  end
end
