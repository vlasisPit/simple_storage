#!/usr/bin/env ruby
require "rubygems" # ruby1.9 doesn't "require" it though
require "thor"

require_relative 'storage/fully_persisted_task_storage'
require_relative 'model/task'
require_relative 'commons/commons'

# THOR_SILENCE_DEPRECATION=false ./crud_app.thor crud_action --create --title 'First test'
# THOR_SILENCE_DEPRECATION=false ./crud_app.thor crud_action --create --title 'First test'
# THOR_SILENCE_DEPRECATION=false ./crud_app.thor crud_action --create --title 'First test' --is_done false --desc "This is a Task num 1"
# THOR_SILENCE_DEPRECATION=false ./crud_app.thor crud_action --read --all
# THOR_SILENCE_DEPRECATION=false ./crud_app.thor crud_action --read --id 1c64d99f-2553-4139-a13e-b67953ac0840
# THOR_SILENCE_DEPRECATION=false ./crud_app.thor crud_action --update --id 1c64d99f-2553-4139-a13e-b67953ac0840 --title 'new title updated'
# ./crud_app.thor crud_action --delete --id ee57e6fe-f193-4319-80a7-0b64f5638b60
class CrudApp < Thor
  include Ruby::Commons::Commons

  desc "Crud operations on Tasks", "Create, Read, Update or Delete tasks"
  method_option :create, :aliases => "-c", :desc => "Create a new task"
  method_option :read, :aliases => "-r", :desc => "Read a task"
  method_option :update, :aliases => "-u", :desc => "Update a task"
  method_option :delete, :aliases => "-d", :desc => "Delete a task"
  method_option :id, :aliases => "-id", :desc => "Id of the task"
  method_option :title, :aliases => "-t", :desc => "Title of the task"
  method_option :is_done, :aliases => "-dn", :desc => "Is done status of the task"
  method_option :desc, :aliases => "-des", :desc => "Description of the task"
  method_option :all, :aliases => "-all", :desc => "Read all tasks (combined with read action)"

  def crud_action
    directory = Dir.home + '/persistedStorage'
    fully_persisted_storage = Ruby::Storage::FullyPersistedTaskStorage.new(directory: directory)

    is_create = options[:create]
    is_read = options[:read]
    is_update = options[:update]
    is_delete = options[:delete]

    if is_create
      create_task_handler(fully_persisted_storage, options)
    elsif is_read
      read_task_handler(fully_persisted_storage, options)
    elsif is_update
      update_task_handler(fully_persisted_storage, options)
    elsif is_delete
      delete_task_handler(fully_persisted_storage, options)
    else
      raise StandardError.new("You need to specify a CRUD action")
    end
  end
end

CrudApp.start
