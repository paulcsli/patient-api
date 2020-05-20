class V1::PatientsController < ApplicationController
  def index
    render plain: "#{Patient.all.to_a}"
    return Patient.all.to_a
  end

  def show
  end

  def create
  end
end
