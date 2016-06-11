class RequestsController
  attr_reader :host

  def initialize(**config)
    @host = config[:host]
  end

  def post(path, params = {})
    response = HTTP.post(generate_url(path), form: params)

    if response.code == 200
      process_response(response)
    else
      { error: process_response(response) }
    end
  end

  def delete(path)
    HTTP.delete(generate_url(path))
  end

  private
    def process_response(response)
      JSON.parse(response.to_s)
    end

    def generate_url(path)
      "#{host}#{path}"
    end

end