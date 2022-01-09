require 'json'

module Ruby
  module Storage
    class FullyPersistedTaskStorage

      def initialize(params = {})
        @directory = params.fetch(:directory, Dir.home + '/persistedStorage')
        Dir.mkdir(@directory) unless File.directory?(@directory)
      end

      def add(value)
        File.write("#{@directory}/#{value.id}", value.to_json)
      end

      def remove(key)
        raise StandardError.new("A valid key should be provided") if key.strip.empty?
        path_to_file = "#{@directory}/#{key}"
        File.delete(path_to_file) if File.exist?(path_to_file)
      end

      def get_with_id(key)
        raise StandardError.new("A valid key should be provided") if key.strip.empty?
        path_to_file = "#{@directory}/#{key}"
        get_task_from_file(path_to_file)
      end

      def update(new_value)
        raise StandardError.new("A valid key should be provided") if new_value.id.strip.empty?
        path_to_file = "#{@directory}/#{new_value.id}"
        raise StandardError.new("Key does not exist in storage") unless File.exist?(path_to_file)
        new_value.updated_at = DateTime.now.iso8601(3)
        File.write(path_to_file, new_value.to_json)
      end

      def all
        files = Dir[File.join(@directory, '**', '*')].select { |file| File.file?(file) }
        files.map { |path_to_file| get_task_from_file(path_to_file) }
             .sort_by { |task| task["updated_at"] }
      end

      private

      def get_task_from_file(path_to_file)
        raise StandardError.new("Key does not exist in storage") unless File.exist?(path_to_file)
        File.open(path_to_file, "r") do |f|
          f.each_line do |line|
            return JSON.parse(line)
          end
        end
      end

    end
  end
end
