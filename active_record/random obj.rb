module ActiveRecord
  class Base
    def self.random(max_records = 10_000)
      find(limit(max_records).pluck(primary_key).sample) rescue nil
    end
  end
end
