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
    # TODO: error handling
    @patient = Patient.find(show_params[:id])
    render json: @patient, :status => :ok
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
    # TODO: error handling
    attributes = JSON.parse(request.body.read).symbolize_keys[:data]
    @new_patient = Patient.create!(attributes)
    render json: @new_patient, :status => :created
  end

  private
  def show_params
    permitted = params.permit(:id).to_hash.symbolize_keys
    permitted
  end
end
