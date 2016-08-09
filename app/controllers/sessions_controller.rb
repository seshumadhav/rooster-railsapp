class SessionsController< ApplicationController

  layout false

  def new
  end

  def create
    omniauth_data = request.env['omniauth.auth']

    @info = omniauth_data['info']
    name = @info['name']
    email = @info['email']

    @auth = omniauth_data['credentials']

    Token.create(
        access_token: @auth['token'],
        refresh_token: @auth['refresh_token'],
        expires_at: Time.at(@auth['expires_at']).to_datetime,
        email: email,
        name: name)
  end
end