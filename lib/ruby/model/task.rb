require 'securerandom'
require 'date'
require_relative 'timestamps'

module Ruby
  module Model
    class Task
      include Ruby::Model::Timestamps
      attr_accessor :id, :title, :is_done, :desc

      def initialize(title, id: nil, is_done: nil, desc: nil)
        @id = id || SecureRandom.uuid
        @title = title
        @is_done = is_done
        @desc = desc
        @created_at = DateTime.now.iso8601(3)
        @updated_at = DateTime.now.iso8601(3)
      end

      def as_json(options = {})
        hash = {}
        self.instance_variables.each do |instance_var|
          hash[instance_var.to_s[1..-1]] = self.instance_variable_get(instance_var)
        end
        hash
      end

      def to_json(*options)
        as_json(*options).to_json(*options)
      end

      def to_s
        "Task: #{@id} / #{@title} / #{@is_done} / #{@desc} / #{@created_at} / #{@updated_at}"
      end
    end
  end
end

