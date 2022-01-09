require_relative './model/task'

module Ruby
  module SimpleStorage
    class Error < StandardError; end
    task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
    task_2 = Ruby::Model::Task.new('Test 2', is_done: false, desc: 'This is Test 2')

    puts task_1
    puts task_2
  end
end