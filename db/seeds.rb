require_relative "db/seeds/_helpers.rb"

ActiveRecord::Base.transaction do
  Dir[Rails.root.join("db/seeds/flows/**/*.rb")].sort.each { |f| load f }
end
puts "[seeds] all done"