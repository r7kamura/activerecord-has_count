require "pathname"
require "pry"
require "active_record"
require "activerecord-has_count"

spec_dir = Pathname.new(File.dirname(__FILE__))
Dir[File.join(spec_dir, "models/*.rb")].each { |f| require f }

require "factory_girl"
Dir[File.join(spec_dir, "support/*.rb")].each { |f| require f }

database_yml = File.join(spec_dir, "database.yml")
ActiveRecord::Base.configurations["test"] = YAML.load_file(database_yml)["test"]
ActiveRecord::Base.establish_connection :test

ActiveRecord::Schema.define do
  create_table :tweets, force: true do |t|
    t.column :replies_count_cache, :integer
    t.column :created_at, :datetime
    t.column :updated_at, :datetime
  end

  create_table :replies, force: true do |t|
    t.column :tweet_id, :integer
    t.column :created_at, :datetime
    t.column :updated_at, :datetime
  end
end

RSpec.configure do |config|
  ALL_MODELS = [
    Tweet,
    Reply,
  ].freeze

  config.after do
    ALL_MODELS.each(&:delete_all)
  end
end
