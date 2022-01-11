#!/usr/bin/env ruby
require "rubygems" # ruby1.9 doesn't "require" it though
require "thor"

require_relative 'storage/fully_persisted_task_storage'
require_relative 'model/task'
require_relative 'commons/commons'

class CrudApp2 < Thor
  include Ruby::Commons::Commons

  # ./crud_app_2.thor create --title 'First test' --is_done false --desc "This is a Task num 1"
  # ./crud_app_2.thor create --title 'Second test' --is_done false --desc "This is a Task num 2"
  desc "Create Task", "Create Task with title"
  method_option :id, :aliases => "-id", :desc => "Id of the task"
  method_option :title, :aliases => "-t", :desc => "Title of the task"
  method_option :is_done, :aliases => "-dn", :desc => "Is done status of the task"
  method_option :desc, :aliases => "-des", :desc => "Description of the task"

  def create
    directory = Dir.home + '/persistedStorage'
    fully_persisted_storage = Ruby::Storage::FullyPersistedTaskStorage.new(directory: directory)
    create_task_handler(fully_persisted_storage, options)
  end

  # ./crud_app_2.thor read --all
  # ./crud_app_2.thor read --id b2d9b43e-3d20-405d-a650-c929c023504a
  desc "Read Tasks", "Read all or one task"
  method_option :id, :aliases => "-id", :desc => "Id of the task"
  method_option :all, :aliases => "-all", :desc => "Read all tasks (combined with read action)"

  def read
    directory = Dir.home + '/persistedStorage'
    fully_persisted_storage = Ruby::Storage::FullyPersistedTaskStorage.new(directory: directory)
    read_task_handler(fully_persisted_storage, options)
  end

  # ./crud_app_2.thor update --id 206ea410-8130-450a-b0ad-e9dfe389cd33 --title 'Updated text !!!'
  desc "Update Task", "Update Task with title, is_done or description"
  method_option :id, :aliases => "-id", :desc => "Id of the task"
  method_option :title, :aliases => "-t", :desc => "Title of the task"
  method_option :is_done, :aliases => "-dn", :desc => "Is done status of the task"
  method_option :desc, :aliases => "-des", :desc => "Description of the task"

  def update
    directory = Dir.home + '/persistedStorage'
    fully_persisted_storage = Ruby::Storage::FullyPersistedTaskStorage.new(directory: directory)
    update_task_handler(fully_persisted_storage, options)
  end

  # ./crud_app_2.thor delete --id b2d9b43e-3d20-405d-a650-c929c023504a
  desc "Delete Tasks", "Delete a task"
  method_option :id, :aliases => "-id", :desc => "Id of the task"

  def delete
    directory = Dir.home + '/persistedStorage'
    fully_persisted_storage = Ruby::Storage::FullyPersistedTaskStorage.new(directory: directory)
    delete_task_handler(fully_persisted_storage, options)
  end

end

CrudApp2.start
