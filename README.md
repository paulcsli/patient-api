# Installation
The app runs in Rails 6, install all necessary tools

git clone the repo to any desired directories

bundle install
rake db:setup
rails server

# How to Use
get	/v1/patients
  summary: Get paginated patient profiles	
  responses:	
    200:
      description: Get a page of 10 patient profiles with the link for next page.	
      schema:	
        required:	
          - data	
          - links	
        properties:	
          data:	
            type: array	
            items:	
              $ref: '#/definitions/patient'	
          links:	
            $ref: '#/definitions/pagination'

get	/v1/patients/{id}
  summary: Get a particular patient profile
  parameters:
    id:
      description: the patient id	
      required: true	
      type: integer	
  responses:
    200:	
      description: patient profile	
      schema:	
        $ref: '#/definitions/patient'	
    404:  	
      description: not found	
      schema:	
        $ref: '#/definitions/http-error'

post /v1/patients	
  summary: Create a patient profile	
  parameters:	
    data:
      required: true
      properties (all required):	
        - email	(type: string)
        - first_name (type: string)
        - last_name (type: string)	
        - birthdate	(type: string, format: date)
        - sex	(type: string)
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

Definitions:
  Pagination:
    required:
      - self
      - next
    properties:
      self:
        type: string
        description: Canonical URL of the current page
      next:
        type: string
        description: URL of next page

  http-error:
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
        description: An error code unique to the error case.
  
  Patient:
    properties: (all required)
      - email	(type: string, unique: true)
      - first_name (type: string)
      - last_name (type: string)	
      - birthdate	(type: string, format: date)
      - sex	(type: string)
