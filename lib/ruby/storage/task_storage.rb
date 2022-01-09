module Ruby
  module Storage
    class TaskStorage
      def initialize
        @storage = {}
      end

      def add(value)
        @storage[value.id] = value
      end

      def remove(key)
        @storage.delete(key)
      end

      def get_with_id(key)
        @storage[key]
      end

      def update(key, new_value)
        raise StandardError.new("Key does not exist in storage") unless @storage.key?(key)
        new_value.updated_at = DateTime.now.iso8601(3)
        @storage[key] = new_value
      end

      def all
        @storage.values
                .sort_by(&:updated_at)
      end

      def get_all_not_done
        @storage.values
                .reject(&:is_done)
      end

      def get_all_contains_substring_in_desc(term)
        @storage.values
                .select { |task| task.desc.include? term }
      end
    end
  end
end


