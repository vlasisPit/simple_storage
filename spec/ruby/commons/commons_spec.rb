require 'ruby/commons/commons'
require 'ruby/storage/fully_persisted_task_storage'
require "ruby/model/task"

RSpec.describe Ruby::Commons::Commons do
  context 'when using crud app CLI by using commons module' do

    include Ruby::Commons::Commons

    let(:directory) do
      Dir.home + '/persistedStorageTest'
    end

    let(:fully_persisted_storage) do
      Ruby::Storage::FullyPersistedTaskStorage.new(directory: directory)
    end

    after :each do
      FileUtils.rm_r directory if File.directory?(directory)
    end

    it 'and when creating 2 tasks, then the tasks should be retrieved with --all option' do
      create_task_handler(fully_persisted_storage, title: 'First task', is_done: false, desc: 'Description for 1st task')
      create_task_handler(fully_persisted_storage, title: 'Second task', is_done: false, desc: 'Description for 2nd task')
      retrieved_tasks = read_task_handler(fully_persisted_storage, all: '')
      expect(retrieved_tasks.size).to eq(2)
    end

    it 'and retrieving task with empty id, error message should be appeared' do
      expect { read_task_handler(fully_persisted_storage, id: '') }.to raise_error(StandardError, "A valid key should be provided")
    end

    it 'and retrieving task with not-valid id, error message should be appeared' do
      expect { read_task_handler(fully_persisted_storage, id: '123') }.to raise_error(StandardError, "Key does not exist in storage")
    end

    it 'and retrieving tasks without id and without --all, error message should be appeared' do
      expect { read_task_handler(fully_persisted_storage, test: '123') }.to raise_error(StandardError, "For read action, --all should be specified or a specific id to retrieve")
    end

    it 'and when creating 1 task and then update this task, then the task should be updated' do
      create_task_handler(fully_persisted_storage, title: 'First task', is_done: false, desc: 'Description for 1st task')
      retrieved_tasks = read_task_handler(fully_persisted_storage, all: '')
      id = retrieved_tasks[0]['id']
      update_task_handler(fully_persisted_storage, id: id, desc: 'Updated desc !!!')
      task = read_task_handler(fully_persisted_storage, id: id)
      expect(task["desc"]).to eq('Updated desc !!!')
    end

    it 'and when creating 1 task and then delete this task, then the task should be deleted' do
      create_task_handler(fully_persisted_storage, title: 'First task', is_done: false, desc: 'Description for 1st task')
      retrieved_tasks = read_task_handler(fully_persisted_storage, all: '')
      id = retrieved_tasks[0]['id']
      expect(retrieved_tasks.size).to eq(1)
      delete_task_handler(fully_persisted_storage, id: id)

      retrieved_tasks = read_task_handler(fully_persisted_storage, all: '')
      expect(retrieved_tasks.size).to eq(0)
    end

    it 'and delete a task without an id, error message should be appeared' do
      expect { delete_task_handler(fully_persisted_storage, test: '123') }.to raise_error(StandardError, "You should provide an id for that action")
    end

    it 'and delete a task with an empty id, error message should be appeared' do
      puts 'test'
      expect { delete_task_handler(fully_persisted_storage, id: '') }.to raise_error(StandardError, "A valid key should be provided")
    end

    it 'and update a task without an id, error message should be appeared' do
      expect { update_task_handler(fully_persisted_storage, test: '123') }.to raise_error(StandardError, "You should provide an id for that action")
    end

    it 'and update a task without an id, error message should be appeared' do
      expect { update_task_handler(fully_persisted_storage, id: '') }.to raise_error(StandardError, "A valid key should be provided")
    end

  end
end
