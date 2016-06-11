class TaskWorker

  include Sidekiq::Worker

  sidekiq_options queue: 'Tasks'

  def perform(task_id, host, callback_url)
    task = Task.find(task_id)

    task.process_image(host, callback_url)
  end

end