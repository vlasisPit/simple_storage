module Ruby
  module Commons
    module Commons
      def create_task_handler(fully_persisted_storage, options)
        title = options[:title]
        desc = options[:desc]
        is_done = options[:is_done]

        raise StandardError.new("Specify a title to create a task") unless title
        task_1 = Ruby::Model::Task.new(title, is_done: is_done, desc: desc)
        fully_persisted_storage.add(task_1)
      end

      def read_task_handler(fully_persisted_storage, options)
        all = options[:all]
        id = options[:id]

        if all
          fully_persisted_storage.all
                                 .each { |task| puts "Task: #{task['id']} / #{task['title']} / #{task['is_done']} / #{task['desc']}" }
        elsif id
          raise StandardError.new("You should provide an id for that action") unless id
          task = fully_persisted_storage.get_with_id(id)
          puts "Task: #{task['id']} / #{task['title']} / #{task['is_done']} / #{task['desc']}"
          task
        else
          raise StandardError.new("For read action, --all should be specified or a specific id to retrieve")
        end
      end

      def update_task_handler(fully_persisted_storage, options)
        id, title, desc, is_done = options.values_at(:id, :title, :desc, :is_done)
        raise StandardError.new("You should provide an id for that action") unless id
        retrieved_task = fully_persisted_storage.get_with_id(id)

        updated_task = Ruby::Model::Task.new(
          title || retrieved_task['title'],
          is_done: is_done || retrieved_task['is_done'],
          desc: desc || retrieved_task['desc'],
          id: retrieved_task['id']
        )

        fully_persisted_storage.update(updated_task)
      end

      def delete_task_handler(fully_persisted_storage, options)
        id = options[:id]
        raise StandardError.new("You should provide an id for that action") unless id
        fully_persisted_storage.remove(id)
      end
    end
  end
end
