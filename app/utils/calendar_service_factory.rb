class CalendarServiceFactory

  def self.get_calendar_service
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = get_google_oauth_client

    service
  end

  private

  def self.get_google_oauth_client
    client = Signet::OAuth2::Client.new({
                                            client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
                                            client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
                                            access_token: Token.last.fresh_token,
                                            token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
                                            grant_type: 'refresh_token'
                                        })
    client.refresh_token = Token.last.refresh_token

    client
  end

end