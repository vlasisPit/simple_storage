require 'rspec'
require 'fileutils'
require "ruby/storage/file_task_storage"
require "ruby/model/task"

RSpec.describe Ruby::Storage::FileTaskStorage do
  context 'when create a new FileTaskStorage' do
    let(:file_task_storage) do
      index = Ruby::Storage::Index.new
      Ruby::Storage::FileTaskStorage.new('task', index, "----")
    end

    after :all do
      directory = 'temp'
      FileUtils.rm_r directory if File.directory?(directory)
    end

    it 'and add a new Task, this Task should be retrieved' do
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      file_task_storage.add(task_1)
      actual_task = file_task_storage.get_with_id(task_1.id)
      expect(task_1.id).to eq(actual_task.id)
    end

    it 'and add two new Tasks, the second task should be retrieved' do
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      task_2 = Ruby::Model::Task.new('Test 2', is_done: false, desc: 'This is Test 2')
      file_task_storage.add(task_1)
      file_task_storage.add(task_2)
      actual_task = file_task_storage.get_with_id(task_2.id)
      expect(task_2.id).to eq(actual_task.id)
    end

    it 'and add ten new Tasks, the ninth task should be retrieved' do
      uuids = []
      10.times do |i|
        task = Ruby::Model::Task.new("Test #{i + 1}", is_done: false, desc: "This is Test #{i + 1}")
        uuids << task.id
        file_task_storage.add(task)
      end
      actual_task = file_task_storage.get_with_id(uuids[8])
      expect(actual_task.desc).to eq("This is Test 9")
    end

    it 'and add ten new Tasks and then delete the ninth, you can not retrieve it' do
      uuids = []
      10.times do |i|
        task = Ruby::Model::Task.new("Test #{i + 1}", is_done: false, desc: "This is Test #{i + 1}")
        uuids << task.id
        file_task_storage.add(task)
      end
      file_task_storage.remove(uuids[8])
      expect { file_task_storage.get_with_id(uuids[8]) }.to raise_error(StandardError, "Key does not exist in storage")
    end

    it 'and add ten new Tasks and then update the ninth, you should see the change' do
      tasks = []
      10.times do |i|
        task = Ruby::Model::Task.new("Test #{i + 1}", is_done: false, desc: "This is Test #{i + 1}")
        tasks << task
        file_task_storage.add(task)
      end
      tasks[8].desc = "Updated description"
      previous_updated_at = tasks[8].updated_at
      sleep(0.1)
      file_task_storage.update(tasks[8].id, tasks[8])
      expect(file_task_storage.get_with_id(tasks[8].id).desc).to eq("Updated description")
      expect(file_task_storage.get_with_id(tasks[8].id).updated_at).not_to eq(previous_updated_at)
    end

    it 'and add ten new Tasks and then try to update with a non existent key, you should retrieve an error' do
      tasks = []
      10.times do |i|
        task = Ruby::Model::Task.new("Test #{i + 1}", is_done: false, desc: "This is Test #{i + 1}")
        tasks << task
        file_task_storage.add(task)
      end
      expect { file_task_storage.update("test_key", tasks[8]) }.to raise_error(StandardError, "Key does not exist in storage")
    end

    it 'and add three new Tasks and then get all of them, you should see the three tasks' do
      tasks = []
      3.times do |i|
        task = Ruby::Model::Task.new("Test #{i + 1}", is_done: false, desc: "This is Test #{i + 1}")
        tasks << task
        file_task_storage.add(task)
      end
      retrieved_tasks = file_task_storage.all
      expect(retrieved_tasks.size).to eq(tasks.size)

      retrieved_tasks.each do |retrieved_task|
        task_to_compare = extract_task_from_array(tasks, retrieved_task['id'])
        expect(retrieved_task['id']).to eq(task_to_compare.id)
        expect(retrieved_task['desc']).to eq(task_to_compare.desc)
        expect(retrieved_task['title']).to eq(task_to_compare.title)
        expect(retrieved_task['is_done']).to eq(task_to_compare.is_done)
      end
    end

    it 'and add three new Tasks, then update one of them and then get all of them, you should see the three tasks' do
      tasks = []
      3.times do |i|
        task = Ruby::Model::Task.new("Test #{i + 1}", is_done: false, desc: "This is Test #{i + 1}")
        tasks << task
        file_task_storage.add(task)
      end
      tasks[2].desc = "Updated description"
      file_task_storage.update(tasks[2].id, tasks[2])

      retrieved_tasks = file_task_storage.all
      expect(retrieved_tasks.size).to eq(tasks.size)

      retrieved_tasks.each do |retrieved_task|
        task_to_compare = extract_task_from_array(tasks, retrieved_task['id'])
        expect(retrieved_task['id']).to eq(task_to_compare.id)
        expect(retrieved_task['desc']).to eq(task_to_compare.desc)
        expect(retrieved_task['title']).to eq(task_to_compare.title)
        expect(retrieved_task['is_done']).to eq(task_to_compare.is_done)
      end
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
      file_task_storage.add(task_1)
      file_task_storage.add(task_2)
      file_task_storage.add(task_3)
      file_task_storage.add(task_4)

      # Before updating
      retrieved_tasks = file_task_storage.all
      expect(retrieved_tasks.size).to eq(4)
      expect(retrieved_tasks[0]['desc']).to eq('This is Test 1')
      expect(retrieved_tasks[1]['desc']).to eq('This is Test 2')
      expect(retrieved_tasks[2]['desc']).to eq('This is Test 3')
      expect(retrieved_tasks[3]['desc']).to eq('This is Test 4')

      # After updating
      task_3.desc = 'Updated description'
      file_task_storage.update(task_3.id, task_3)
      retrieved_tasks = file_task_storage.all
      expect(retrieved_tasks.size).to eq(4)
      expect(retrieved_tasks[0]['desc']).to eq('This is Test 1')
      expect(retrieved_tasks[1]['desc']).to eq('This is Test 2')
      expect(retrieved_tasks[2]['desc']).to eq('This is Test 4')
      expect(retrieved_tasks[3]['desc']).to eq('Updated description')
    end

    def extract_task_from_array(tasks, id)
      tasks.each do |task|
        if task.id == id
          return task
        end
      end
      raise "Task not found"
    end
  end
end


