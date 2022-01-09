require 'rspec'
require "ruby/storage/task_storage"
require "ruby/model/task"

RSpec.describe Ruby::Storage::TaskStorage do
  context 'when create a new TaskStorage' do
    let(:task_storage) do
      Ruby::Storage::TaskStorage.new
    end
    it 'storage should be empty' do
      expect(task_storage.all.size).to eq(0)
    end

    it 'storage size should be one, if a task is added before' do
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      task_storage.add(task_1)
      expect(task_storage.all.size).to eq(1)
    end

    it 'retrieve task when the task has been added before' do
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      task_2 = Ruby::Model::Task.new('Test 2', is_done: false, desc: 'This is Test 2')
      task_3 = Ruby::Model::Task.new('Test 3', is_done: false, desc: 'This is Test 3')
      task_storage.add(task_1)
      task_storage.add(task_2)
      task_storage.add(task_3)
      expect(task_storage.all.size).to eq(3)

      actual_task = task_storage.get_with_id(task_1.id)
      expect(actual_task.title).to eq('Test 1')
      expect(actual_task.is_done).to eq(false)
      expect(actual_task.desc).to eq('This is Test 1')
    end

    it 'storage size should be zero, if a task is added and then deleted' do
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      task_storage.add(task_1)
      expect(task_storage.all.size).to eq(1)
      task_storage.remove(task_1.id)
      expect(task_storage.all.size).to eq(0)
    end

    it 'Description should be change, if desc property is updated first' do
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      task_storage.add(task_1)
      expect(task_storage.all.size).to eq(1)
      task_1.desc = 'Updated desc !!!'
      previous_updated_at = task_1.created_at
      sleep(0.1)
      task_storage.update(task_1.id, task_1)
      expect(task_storage.get_with_id(task_1.id).desc).to eq('Updated desc !!!')
      expect(task_storage.get_with_id(task_1.id).updated_at).not_to eq(previous_updated_at)
    end

    it 'An error should be raised, when the key does not exist in hash in an update operation' do
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      expect { task_storage.update(task_1.id, task_1) }.to raise_error(StandardError, "Key does not exist in storage")
    end

    it 'retrieve not completed tasks' do
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      task_2 = Ruby::Model::Task.new('Test 2', is_done: false, desc: 'This is Test 2')
      task_3 = Ruby::Model::Task.new('Test 3', is_done: true, desc: 'This is Test 3')
      task_storage.add(task_1)
      task_storage.add(task_2)
      task_storage.add(task_3)
      expect(task_storage.all.size).to eq(3)

      not_done_tasks = task_storage.get_all_not_done
      expect(not_done_tasks.size).to eq(2)
    end

    it 'retrieve tasks that contains sub-string "Ruby" on description property' do
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      task_2 = Ruby::Model::Task.new('Test 2', is_done: false, desc: 'This is Test 2')
      task_3 = Ruby::Model::Task.new('Test 3', is_done: true, desc: 'This is Test 3')
      task_4 = Ruby::Model::Task.new('Test 4', is_done: true, desc: 'Ruby training')
      task_storage.add(task_1)
      task_storage.add(task_2)
      task_storage.add(task_3)
      task_storage.add(task_4)
      expect(task_storage.all.size).to eq(4)

      retrieved_tasks = task_storage.get_all_contains_substring_in_desc('Ruby')
      expect(retrieved_tasks.size).to eq(1)
      expect(retrieved_tasks[0].desc).to eq('Ruby training')
    end

    it 'all retrieved tasks should be presented in sorted order according to updated_at' do
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      sleep(0.1)
      task_2 = Ruby::Model::Task.new('Test 2', is_done: false, desc: 'This is Test 2')
      sleep(0.1)
      task_3 = Ruby::Model::Task.new('Test 3', is_done: true, desc: 'This is Test 3')
      sleep(0.1)
      task_4 = Ruby::Model::Task.new('Test 4', is_done: true, desc: 'This is Test 4')
      sleep(0.1)
      task_storage.add(task_1)
      task_storage.add(task_2)
      task_storage.add(task_3)
      task_storage.add(task_4)

      # Before updating
      retrieved_tasks = task_storage.all
      expect(retrieved_tasks.size).to eq(4)
      expect(retrieved_tasks[0].desc).to eq('This is Test 1')
      expect(retrieved_tasks[1].desc).to eq('This is Test 2')
      expect(retrieved_tasks[2].desc).to eq('This is Test 3')
      expect(retrieved_tasks[3].desc).to eq('This is Test 4')

      # After updating
      task_3.desc = 'Updated description'
      task_storage.update(task_3.id, task_3)
      retrieved_tasks = task_storage.all
      expect(retrieved_tasks.size).to eq(4)
      expect(retrieved_tasks[0].desc).to eq('This is Test 1')
      expect(retrieved_tasks[1].desc).to eq('This is Test 2')
      expect(retrieved_tasks[2].desc).to eq('This is Test 4')
      expect(retrieved_tasks[3].desc).to eq('Updated description')
    end

  end

end