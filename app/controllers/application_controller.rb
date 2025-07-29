class ApplicationController < ActionController::API
  # before_action :set_custom_header

  # private

  # def set_custom_header
  #   my_header = request.headers["X-My-Custom-Header"]
  #   unless my_header == "123456"
  #     render json: { error: "Unauthorized", status: :Unauthorized }
  #   end
  # end
  #

  before_action :authenticate_request

  # Catch all ActiveRecord not found errors
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # Catch all validation errors
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  # Catch any other unexpected error
  rescue_from StandardError, with: :handle_internal_server_error

  def route_not_found
    puts "working 404 ======================>"
    render json: { error: "Route not found" }, status: :not_found
  end
private
  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def record_invalid(error)
    render json: { error: error.record.errors.full_message }, status: :unprocessable_entity
  end

  def handle_internal_server_error(error)
    Rails.logger.error(error.full_message)
    render json: { error: "Internal server error" }, status: :internal_server_error
  end

  def authenticate_request
    token = request.headers["Authorization"]&.split(" ")&.last
    raise JWT::DecodeError, "Token not provided" unless token

    decoded_token = JsonWebToken.decode(token)

    @current_user = User.find(decoded_token[:user_id])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
    render json: { error: "Unauthorized: #{e.message}" }, status: :unauthorized
  end
end
