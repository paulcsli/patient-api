# Installation
The app runs in Rails 6, install all necessary tools

git clone the repo to any desired directories

bundle install
rake db:setup
rails server

# How to Use
## get /v1/patients
summary: Get paginated patient profiles</br>
responses:</br>
  * 200</br> 
    description: Get a page of 10 patient profiles with the link for next page.</br>
    schema:</br>
    * required:</br>
      * data</br>
      * links</br>
    * properties:</br> 	
      * data:</br>
        * type: array</br>
        * items:</br>
            $ref: '#/definitions/patient'</br>
      * links:</br>
          $ref: '#/definitions/pagination'</br>

## get /v1/patients/{id}
summary: Get a particular patient profile</br>
parameters:</br>
  * id</br>
      description: the patient id</br>
      required: true</br>
      type: integer</br>

responses:</br>
  * 200</br>
      description: patient profile</br>
      schema:</br>
    * $ref: #/definitions/patient</br>
  * 404</br>
      description: not found</br>
      schema:</br>
    * $ref: #/definitions/http-error</br>

## post /v1/patients	
summary: Create a patient profile</br>
parameters:</br>
  * data</br>
      required: true</br>
      properties (all required):</br>
    * email</br>
      * type: string</br>
    * first_name</br>
      * type: string</br>
    * last_name</br>
      * type: string</br>
    * birthdate</br>
      * type: string</br>
    * sex</br>
      * type: string</br>

responses:</br>
  * 201:</br>
      description: A patient profile.</br>
      schema:	</br>
    * $ref: #/definitions/patient</br>
  * 400:</br>
      description: Required field missing or bad format.</br>
      schema:</br>
    * $ref: #/definitions/http-error</br>
  * 409:</br>
      description: Email duplicates</br>
      schema:	</br>
    * $ref: #/definitions/http-error</br>

## Definitions:
Pagination:</br>
  * properties:</br>
    * self</br>
      * required: true</br>
      * type: string</br>
      * description: Canonical URL of the current page</br>
    * next</br>
      * required: true</br>
      * type: string</br>
      * description: URL of next page</br>

http-error:</br>
  * properties:</br>
    * id</br>
      * type: string</br>
      * description: Request unique identifier.</br>
    * status</br>
      * type: string</br>
      * description: HTTP status code.</br>
    * title</br>
      * type: string</br>
      * description: HTTP status.</br>
    * detail</br>
      * type: string</br>
      * description: Human readable detail.</br>
    * code</br>
      * type: string</br>
      * description: An error code unique to the error case.</br>

Patient:</br>
  * properties: (all required)</br>
    * email</br>
      * type: string</br>
      * unique: true</br>
    * first_name</br>
      * type: string</br>
    * last_name</br>
      * type: string</br>
    * birthdate</br>
      * type: string</br>
      * format: date</br>
    * sex</br>
      * type: string</br>
