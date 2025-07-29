class AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [ :register, :login ]

  def register
    puts "***** Process register *****"
    user = User.new(register_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { user: user, token: token }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    puts "***** Process login *****"
    # binding.pry  # pauses here
    user = User.find_by(email: params[:email])
    puts user
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { user: user, token: token }, status: :ok
    else
      render json: { message: "Invalid email or password" }, status: :unauthorized
    end
  end

  private
  def register_params
    params.permit(:email, :password, :company, :status, :role)
  end
end
