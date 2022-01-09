module Ruby
  module Storage
    class Index

      def initialize
        @storage = {}
      end

      def add(key, value)
        @storage[key] = value
      end

      def get_with_id(key)
        @storage[key]
      end

      def update(key, new_value)
        @storage[key] = new_value
      end

      def remove(key)
        @storage.delete(key)
      end

      def key?(key)
        @storage.key?(key)
      end
    end
  end
end
