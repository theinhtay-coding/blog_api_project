class ApplicationController < ActionController::API
  # include Pundit
  include Pundit::Authorization

  before_action :authenticate_request

  # Catch all ActiveRecord not found errors
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # Catch all validation errors
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  # Catch any other unexpected error
  rescue_from StandardError, with: :handle_internal_server_error

  # Handle unauthorized error
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def route_not_found
    render json: { error: "Route not found" }, status: :not_found
  end

  def res(data = {}, status = :ok, message = nil, meta: nil)
    payload = data.is_a?(String) ? [ data ] : data
    render json: {
      data: payload
    }.tap { |r| r[:meta] = meta if meta }, status: status
  end

private
  def validate_req(schema)
    result = schema.call(params.to_unsafe_h)
    raise InvalidRequestException.new(result.errors.to_h) unless result.success?
    binding.pry
    result
  end

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

  def user_not_authorized(exception)
    render json: { error: "Access denied: #{exception.policy.class} #{exception.query}" }, status: :forbidden
  end

  def authenticate_request
    token = request.headers["Authorization"]&.split(" ")&.last
    raise JWT::DecodeError, "Token not provided" unless token
    decoded_token = JsonWebToken.decode(token)
    raise JWT::DecodeError, "Invalid token" unless decoded_token
    @current_user = User.find(decoded_token[:user_id])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
    render json: { error: "Unauthorized: #{e.message}" }, status: :unauthorized
  end

  def current_user
    @current_user
  end
end
