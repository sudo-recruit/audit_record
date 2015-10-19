require 'active_record'
require 'logger'

ActiveRecord::Base.establish_connection
ActiveRecord::Base.logger = Logger.new(Pathname.new(File.expand_path('../debug.log', __FILE__)))
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
    t.column :name, :string
    t.column :username, :string
    t.column :password, :string
    t.column :activated, :boolean
    t.column :suspended_at, :datetime
    t.column :logins, :integer, :default => 0
    t.column :created_at, :datetime
    t.column :updated_at, :datetime
  end
end  