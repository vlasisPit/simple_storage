require 'rspec'
require 'fileutils'
require 'ruby/storage/fully_persisted_task_storage'
require "ruby/model/task"

RSpec.describe Ruby::Storage::FullyPersistedTaskStorage do
  context 'when create a new FullyPersistedTaskStorage' do

    let(:fully_persisted_storage) do
      directory = 'persistedStorage'
      Ruby::Storage::FullyPersistedTaskStorage.new(directory: directory)
    end

    before :each do
      directory = 'persistedStorage'
      FileUtils.rm_r directory if File.directory?(directory)
    end

    after :all do
      directory = 'persistedStorage'
      FileUtils.rm_r directory if File.directory?(directory)
    end

    it 'and add a new Task, this Task should be persisted' do
      fully_persisted_storage = Ruby::Storage::FullyPersistedTaskStorage.new(directory: 'persistedStorage')
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      fully_persisted_storage.add(task_1)
      actual_number_of_files = Dir[File.join('persistedStorage', '**', '*')].count { |file| File.file?(file) }
      actual_files = Dir[File.join('persistedStorage', '**', '*')].select { |file| File.file?(file) }
      expect(actual_number_of_files).to eq(1)
      expect(actual_files).to include('persistedStorage/' + task_1.id)
    end

    it 'and two new Tasks, those Tasks should be persisted' do
      fully_persisted_storage = Ruby::Storage::FullyPersistedTaskStorage.new(directory: 'persistedStorage')
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      task_2 = Ruby::Model::Task.new('Test 2', is_done: false, desc: 'This is Test 2')
      fully_persisted_storage.add(task_1)
      fully_persisted_storage.add(task_2)
      actual_number_of_files = Dir[File.join('persistedStorage', '**', '*')].count { |file| File.file?(file) }
      actual_files = Dir[File.join('persistedStorage', '**', '*')].select { |file| File.file?(file) }
      expect(actual_number_of_files).to eq(2)
      expect(actual_files).to include('persistedStorage/' + task_1.id)
      expect(actual_files).to include('persistedStorage/' + task_2.id)
    end

    it 'and two new Tasks, then delete one Task, then this task should be deleted' do
      fully_persisted_storage = Ruby::Storage::FullyPersistedTaskStorage.new(directory: 'persistedStorage')
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      task_2 = Ruby::Model::Task.new('Test 2', is_done: false, desc: 'This is Test 2')
      fully_persisted_storage.add(task_1)
      fully_persisted_storage.add(task_2)
      actual_number_of_files = Dir[File.join('persistedStorage', '**', '*')].count { |file| File.file?(file) }
      actual_files = Dir[File.join('persistedStorage', '**', '*')].select { |file| File.file?(file) }
      expect(actual_number_of_files).to eq(2)
      expect(actual_files).to include('persistedStorage/' + task_1.id)
      expect(actual_files).to include('persistedStorage/' + task_2.id)

      fully_persisted_storage.remove(task_1.id)
      actual_number_of_files = Dir[File.join('persistedStorage', '**', '*')].count { |file| File.file?(file) }
      actual_files = Dir[File.join('persistedStorage', '**', '*')].select { |file| File.file?(file) }
      expect(actual_number_of_files).to eq(1)
      expect(actual_files).not_to include('persistedStorage/' + task_1.id)
    end

    it 'and two new Tasks, then fetch one Task, then this task should be retrieved successfully' do
      fully_persisted_storage = Ruby::Storage::FullyPersistedTaskStorage.new(directory: 'persistedStorage')
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      task_2 = Ruby::Model::Task.new('Test 2', is_done: false, desc: 'This is Test 2')
      fully_persisted_storage.add(task_1)
      fully_persisted_storage.add(task_2)
      actual_number_of_files = Dir[File.join('persistedStorage', '**', '*')].count { |file| File.file?(file) }
      actual_files = Dir[File.join('persistedStorage', '**', '*')].select { |file| File.file?(file) }
      expect(actual_number_of_files).to eq(2)
      expect(actual_files).to include('persistedStorage/' + task_1.id)
      expect(actual_files).to include('persistedStorage/' + task_2.id)

      task = fully_persisted_storage.get_with_id(task_1.id)
      expect(task['id']).to eq(task_1.id)
      expect(task['desc']).to eq(task_1.desc)
      expect(task['title']).to eq(task_1.title)
      expect(task['is_done']).to eq(task_1.is_done)
    end

    it 'and two new Tasks, then update one Task, then this task should be updated successfully' do
      fully_persisted_storage = Ruby::Storage::FullyPersistedTaskStorage.new(directory: 'persistedStorage')
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      task_2 = Ruby::Model::Task.new('Test 2', is_done: false, desc: 'This is Test 2')
      fully_persisted_storage.add(task_1)
      fully_persisted_storage.add(task_2)
      actual_number_of_files = Dir[File.join('persistedStorage', '**', '*')].count { |file| File.file?(file) }
      actual_files = Dir[File.join('persistedStorage', '**', '*')].select { |file| File.file?(file) }
      expect(actual_number_of_files).to eq(2)
      expect(actual_files).to include('persistedStorage/' + task_1.id)
      expect(actual_files).to include('persistedStorage/' + task_2.id)

      task_1.desc = "Updated description !!!"
      previous_updated_at = task_1.updated_at
      sleep(0.1)
      fully_persisted_storage.update(task_1)
      task = fully_persisted_storage.get_with_id(task_1.id)

      expect(task['id']).to eq(task_1.id)
      expect(task['desc']).to eq("Updated description !!!")
      expect(task['title']).to eq(task_1.title)
      expect(task['is_done']).to eq(task_1.is_done)
      expect(task['updated_at']).not_to eq(previous_updated_at)
    end

    it 'Update one Task when the task does not exist, then this task should NOT be updated' do
      fully_persisted_storage = Ruby::Storage::FullyPersistedTaskStorage.new(directory: 'persistedStorage')
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      expect { fully_persisted_storage.update(task_1) }.to raise_error(StandardError, "Key does not exist in storage")
    end

    it 'and two new Tasks, then get all tasks, then all tasks should be retrieved successfully' do
      fully_persisted_storage = Ruby::Storage::FullyPersistedTaskStorage.new(directory: 'persistedStorage')
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      task_2 = Ruby::Model::Task.new('Test 2', is_done: false, desc: 'This is Test 2')
      fully_persisted_storage.add(task_1)
      fully_persisted_storage.add(task_2)
      actual_number_of_files = Dir[File.join('persistedStorage', '**', '*')].count { |file| File.file?(file) }
      actual_files = Dir[File.join('persistedStorage', '**', '*')].select { |file| File.file?(file) }
      expect(actual_number_of_files).to eq(2)
      expect(actual_files).to include('persistedStorage/' + task_1.id)
      expect(actual_files).to include('persistedStorage/' + task_2.id)

      tasks = fully_persisted_storage.all
      expect(tasks.size).to eq(2)
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
      fully_persisted_storage.add(task_1)
      fully_persisted_storage.add(task_2)
      fully_persisted_storage.add(task_3)
      fully_persisted_storage.add(task_4)

      # Before updating
      retrieved_tasks = fully_persisted_storage.all
      expect(retrieved_tasks.size).to eq(4)
      expect(retrieved_tasks[0]['desc']).to eq('This is Test 1')
      expect(retrieved_tasks[1]['desc']).to eq('This is Test 2')
      expect(retrieved_tasks[2]['desc']).to eq('This is Test 3')
      expect(retrieved_tasks[3]['desc']).to eq('This is Test 4')

      # After updating
      task_3.desc = 'Updated description'
      fully_persisted_storage.update(task_3)
      retrieved_tasks = fully_persisted_storage.all
      expect(retrieved_tasks.size).to eq(4)
      expect(retrieved_tasks[0]['desc']).to eq('This is Test 1')
      expect(retrieved_tasks[1]['desc']).to eq('This is Test 2')
      expect(retrieved_tasks[2]['desc']).to eq('This is Test 4')
      expect(retrieved_tasks[3]['desc']).to eq('Updated description')
    end

  end
end
