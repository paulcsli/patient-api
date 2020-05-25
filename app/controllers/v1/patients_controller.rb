class V1::PatientsController < ApplicationController
  PAGINATION_SIZE = 10
  before_action :get_page_index, only: [:index]

  def index
    render json: {
      data: Patient.limit(10).offset(@page_index * PAGINATION_SIZE).to_a.map { |p| p.generate_patient_response('test')},
      links: PaginationLinkCreator.new(
        request.base_url,
        @page_index,
        PAGINATION_SIZE
      ).generate_link,
    }, :status => :ok
  end

  def show
    @patient = Patient.find(show_params[:id])
    render json: @patient.generate_patient_response(request.base_url), :status => :ok
  rescue ActiveRecord::RecordNotFound => e
    error = HttpErrorCreator.new(
      request_id: request.uuid,
      error_type: ActiveRecord::RecordNotFound,
      error_msg: e.to_s,
      patient: @patient,
    )
    render json: error.generate_response, status: error.status_code
  end

  def create
    request_body = request.body.read
    attributes = request_body.empty? ? {} : JSON.parse(request_body)["data"]
    @new_patient = Patient.create(attributes)

    if @new_patient.valid?
      render json: @new_patient.generate_patient_response(request.base_url), :status => :created
    else
      error = HttpErrorCreator.new(
        request_id: request.uuid,
        error_type: ActiveRecord::RecordInvalid,
        patient: @new_patient,
      )
      render json: error.generate_response, status: error.status_code
    end
  end

  private
  def show_params
    permitted = params.permit(:id).to_hash.symbolize_keys
    permitted
  end

  def get_page_index
    params.permit(:page_number)
    @page_index = params.has_key?(:page_number) ? params[:page_number].to_i - 1 : 0
  end
end
