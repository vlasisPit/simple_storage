require 'rspec'
require "ruby/model/task"

RSpec.describe Ruby::Model::Task do
  context 'when create a new Task' do
    it 'should have the given title' do
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      expect(task_1.title).to eq('Test 1')
      expect(task_1.created_at).not_to be(nil)
      expect(task_1.updated_at).not_to be(nil)
    end
  end

  context 'when create a new Task' do
    it 'Id should be a UUID' do
      task_1 = Ruby::Model::Task.new('Test 1', is_done: false, desc: 'This is Test 1')
      expect(validate_uuid_format(task_1.id)).to eq(true)
      expect(task_1.created_at).not_to be(nil)
      expect(task_1.updated_at).not_to be(nil)
    end
  end
end

def validate_uuid_format(uuid)
  uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
  return true if uuid_regex.match?(uuid.to_s.downcase)
end
