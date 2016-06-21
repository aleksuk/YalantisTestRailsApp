class Api::TasksController < Api::BaseController

  def create
    image = current_user.images.find(params[:image_id])
    task = current_user.tasks.create! image: image, processing_params: params[:params]

    TaskWorker.perform_async(task.id, request.base_url, api_task_url(task))

    render_response task, 201
  end

  def update
    task = Task.find(params[:id])
    task.process_result(params[:image])

    render_response task, 200
  end

end
