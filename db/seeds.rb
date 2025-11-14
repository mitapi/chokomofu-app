require_relative "seeds/_helpers"

ActiveRecord::Base.transaction do
  Dir[Rails.root.join("db/seeds/flows/**/*.rb")].sort.each do |path|
    puts "[seeds] load: #{path}"   # ← デバッグ
    load path
  end
end

puts "[seeds] all done"