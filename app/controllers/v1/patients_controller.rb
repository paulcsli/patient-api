class V1::PatientsController < ApplicationController
  `get:
    summary: Get paginated patient profiles
    responses:
      200:
        description: |
          Get a page of 10 patient profiles with the link for next page.
        schema:
          type: object
          required:
            - data
            - links
          properties:
            data:
              type: array
              items:
                $ref: '#/definitions/patient'
            links:
              $ref: '#/definitions/pagination'`
  def index
    # TODO: pagination
    render json: {data: Patient.all.to_a}, :status => :ok
  end

  `parameters:
    - name: id
      in: path
      description: the patient id
      required: true
      type: number
    responses:
      200:
        description: patient profile
        schema:
          $ref: '#/definitions/patient'
      404:  
        description: not found
        schema:
          $ref: '#/definitions/http-error'`
  def show
    @patient = Patient.find(show_params[:id])
    render json: @patient, :status => :ok
  rescue ActiveRecord::RecordNotFound => e
    error = HttpErrorCreator.new(
      request_id: request.uuid,
      error_type: ActiveRecord::RecordNotFound,
      error_msg: e.to_s,
      patient: @patient,
    )
    render json: error.generate_response, status: error.status_code
  end

  `post:
  summary: Creates a patient profile
  responses:
    201:
      description: A patient profile.
      schema:
        $ref: '#/definitions/patient'
    400:
      description: Required field missing or bad format.
      schema:
        $ref: '#/definitions/http-error'
    409:
      description: Email duplicates
      schema:
        $ref: '#/definitions/http-error'
  parameters:
    - name: body
      in: body
      schema:
        type: object
        required:
          - data
        properties:
          data:
            type: object
            required:
              - email
              - first_name
              - last_name
              - birthdate
              - sex
            properties:
              email:
                type: string
              first_name:
                type: string
              last_name:
                type: string
              birthdate:
                type: string
                format: date
              sex:
                type: string`
  def create
    attributes = JSON.parse(request.body.read).symbolize_keys[:data]
    @new_patient = Patient.create(attributes)

    if @new_patient.valid?
      render json: @new_patient, :status => :created
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
end
