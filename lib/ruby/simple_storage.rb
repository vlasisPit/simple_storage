require_relative './model/task'
require_relative './storage/task_storage'

module Ruby
  module SimpleStorage
    class Error < StandardError; end
    task_storage = Ruby::Storage::TaskStorage.new

    task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
    task_2 = Ruby::Model::Task.new('Test 2', is_done: false, desc: 'This is Test 2')

    task_storage.add(task_1)
    task_storage.add(task_2)

    puts task_storage.get_with_id(task_1.id).is_done == false
    puts task_storage.all.count == 2
  end
end