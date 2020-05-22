class HttpErrorCreator
  attr_reader :status_code
  ` 
  http-error:
    type: object
    properties:
      error:
        type: object
        properties:
          id:
            type: string
            description: Request unique identifier.
          status:
            type: string
            description: HTTP status code.
          title:
            type: string
            description: HTTP status.
          detail:
            type: string
            description: Human readable detail.
          code:
            type: string
            description: An error code unique to the error case.`
  def initialize(request_id: nil, error_type:, errors: nil)
    @request_id = request_id
    @error_type = error_type
    @errors = errors
    @status_code, @status = generate_http_status()
  end

  def generate_http_status
    if @error_type == ActiveRecord::RecordNotFound
      return 404, "Not Found"
    elsif @error_type == ActiveRecord::RecordInvalid
      if @errors[:email].include?("has already been taken")
        return 409, "Conflict"
      else
        return 400, "Bad Request"
      end
    end
  end

  def error_msg_trimming
    if @error_type == ActiveRecord::RecordNotFound
      @errors
    elsif @error_type == ActiveRecord::RecordInvalid
      details = []
      error_msg_hash = @errors.messages
      error_msg_hash.each do |attribute, msgs|
        msgs.each do |msg|
          details << "#{attribute} #{msg};"
        end
      end
      details.join(' ')
    end
  end

  def generate_response
    {
      # id: @request_id.to_s,
      status: @status_code.to_s,
      title: @status,
      detail: error_msg_trimming(),
      code: @status_code,
    }
  end
end
