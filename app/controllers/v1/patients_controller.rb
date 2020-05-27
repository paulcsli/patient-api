class V1::PatientsController < ApplicationController
  CREATE_PERMITTABLES = Set[:email, :first_name, :last_name, :sex, :birthdate]

  before_action :get_page_index, only: [:index]

  def index
    render json: PaginationCreator.new(
      request.base_url,
      @page_index,
    ).generate_pagination, :status => :ok
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
    @new_patient = Patient.create(create_params)

    if @new_patient.valid?
      render json: @new_patient.generate_patient_response(request.base_url),
      :status => :created
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
    params.permit(:id).to_hash.symbolize_keys
  end

  def create_params
    params.require(:data).each_key do |k|
      params.permit(k) if CREATE_PERMITTABLES.include?(k)
    end
  rescue ActionController::ParameterMissing => e
    {}
  end

  def get_page_index
    params.permit(:page_number)
    @page_index = params.has_key?(:page_number) ? params[:page_number].to_i - 1 : 0
  end
end
