class HttpErrorCreator
  attr_reader :status_code

  ERROR_CODE_MAPPING = {
    :duplicate_email => [409, "Conflict"],
    :bad_format => [400, "Bad Request"],
    :record_not_found => [404, "Not Found"]
  }
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
  def initialize(request_id: nil, error_type:, error_msg: nil, patient: nil)
    @request_id = request_id
    @error_type = error_type
    @error_msg = error_msg
    @patient = patient
    @status_code, @status = generate_http_status()
  end

  def generate_http_status
    if @error_type == ActiveRecord::RecordNotFound
      ERROR_CODE_MAPPING[:record_not_found]
    elsif @error_type == ActiveRecord::RecordInvalid
      ERROR_CODE_MAPPING[@patient.error_type]
    end
  end

  def generate_error_details
    if @error_type == ActiveRecord::RecordNotFound
      @error_msg
    elsif @error_type == ActiveRecord::RecordInvalid
      @patient.format_error_msgs
    end
  end

  def generate_response
    {
      id: @request_id.to_s,
      status: @status_code.to_s,
      title: @status,
      detail: generate_error_details(),
      code: @status_code,
    }
  end
end
