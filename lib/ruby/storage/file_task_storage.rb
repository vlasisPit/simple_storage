require "ruby/storage/index"
require 'json'

module Ruby
  module Storage
    class FileTaskStorage
      def initialize(filename, index, delimiter)
        @@line_cnt = 1
        @delimiter = delimiter
        directory = 'temp'
        FileUtils.rm_r directory if File.directory?(directory)
        Dir.mkdir(directory)
        @file_path = "#{directory}/#{filename}"
        @index = index
      end

      # TODO synchronization should be implemented
      def add(value)
        create_or_update(value.id, value)
      end

      # Remove from index, so you cant find the value
      def remove(key)
        @index.remove(key)
      end

      def get_with_id(key)
        raise StandardError.new("Key does not exist in storage") unless @index.key?(key)
        line_num = @index.get_with_id(key)
        json_string = get_line(line_num).split(@delimiter)[1]
        JSON.parse(json_string, object_class: OpenStruct)
      end

      # TODO synchronization should be implemented
      def update(key, new_value)
        raise StandardError.new("Key does not exist in storage") unless @index.key?(key)
        new_value.updated_at = DateTime.now.iso8601(3)
        create_or_update(key, new_value)
      end

      def all
        temp_storage = {}
        File.open(@file_path, "r") do |f|
          f.each_line do |line|
            line_parts = line.split(@delimiter)
            temp_storage[line_parts[0]] = JSON.parse(line_parts[1])
          end
        end
        temp_storage.values
                    .sort_by{|task| task["updated_at"]}
      end

      private

      def create_or_update(key, value)
        File.write(File.join(Dir.pwd, @file_path), "#{key}#{@delimiter}#{value.to_json}" + "\n", mode: 'a+')
        @index.add(key, @@line_cnt)
        @@line_cnt += 1
      end

      def get_line(lineno)
        File.open(@file_path, 'r') do |f|
          f.gets until f.lineno == lineno - 1
          f.gets
        end
      end
    end
  end
end
