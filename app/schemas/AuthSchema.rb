module AuthSchema
  Register = Dry::Schema.Params do
    required(:email).filled(:string, format?: /@/)
    required(:password).filled(:string, min_size?: 8)
    required(:company).filled(:string)
  end

  Login = Dry::Schema.Params do
    required(:email).filled(:string, format?: /@/)
    required(:password).filled(:string, min_size?: 6)
  end
end
