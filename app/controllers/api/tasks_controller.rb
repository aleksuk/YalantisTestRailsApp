class Api::TasksController < Api::BaseController

  def create
    image = Image.find(params[:image_id])
    task = current_user.tasks.create! image: image, params: get_processing_params

    TaskWorker.perform_async(task.id, request.base_url, api_task_url(task))

    render_response task, 201
  end

  def update
    task = Task.find(params[:id])
    result = get_json(params[:image])

    task.process_result(result)

    render_response task, 200
  end

  private
    def get_processing_params
      image_params = params[:params]

      if image_params.is_a?(Hash)
        image_params.to_json
      else
        image_params = {}
        image_params.to_json
      end
    end

end
