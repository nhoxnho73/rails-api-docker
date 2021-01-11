class Devise::SessionsController < DeviseTokenAuth::SessionsController
  def create
    #check
    field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first
    @resource = nil
    if field
      q_value = resource_params[field]

      if resource_class.case_insensitive_keys.include?(field)
        q_value.downcase!
      end

      q = "#{field.to_s} = ? AND provider='email'"

      if ActiveRecord::Base.connection.adapter_name.downcase.start_with? "mysql"
        q = "BINARY " + q
      end
      # LOG IN BY EMAIL AND USERNAME
      # if field == :login
        # @resource = resource_class.where("email = ? OR username = ?", q_value, q_value).first
      # else
        @resource = resource_class.where(q, q_value).first
      # end
      # LOG IN BY EMAIL AND USERNAME END
    end

    if @resource && valid_params?(field, q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
      valid_password = @resource.valid_password?(resource_params[:password])
      if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_password }) || !valid_password
        render_create_error_bad_credentials
        return
      end
      # create client id
      @client_id = SecureRandom.urlsafe_base64(nil, false)
      @token     = @resource.create_token

      @resource.tokens[@client_id] = {
        token: BCrypt::Password.create(@token),
        expiry: (Time.now + ::DeviseTokenAuth.token_lifespan).to_i
      }
      @resource.save

      sign_in(:user, @resource, store: false, bypass: false)

      yield @resource if block_given?

      render_create_success
    elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
      if @resource.respond_to?(:locked_at) && @resource.locked_at
        render_create_error_account_locked
      else
        render_create_error_not_confirmed
      end
    else
      render_create_error_bad_credentials
    end
    
  end

  def destroy
    super do |resource|
      resource.update! onesignal_id: nil
    end
  end

  def render_create_success
    render json: {success: true, data: JSON.parse(@resource.to_builder.target!)}
  end

  def render_create_error_not_confirmed
    render json: {
      code: 'session_not_confirmed_error'
    }, status: 401
  end

  def render_create_error_account_locked
    render json: {
      code: 'session_account_locked_error'
    }, status: 401
  end

  def render_create_error_bad_credentials
    render json: {
      code: 'session_bad_credentials_error',
      remaining_attempts: @resource.try(:failed_attempts) && @resource.class.maximum_attempts - @resource.try(:failed_attempts)
    }, status: 401
  end
end
