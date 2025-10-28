# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  include ActionController::Cookies

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: e.message }, status: :not_found
  end

  rescue_from ArgumentError do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
