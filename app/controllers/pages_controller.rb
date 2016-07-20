class PagesController < ApplicationController
  def home
  end

  def profile
  end

  def calendar
    @calendar_authorised = false
    begin
      calendar_client = Signet::OAuth2::Client.new(access_token: current_user.google_account.fresh_token)
      calendar_service = Google::Apis::CalendarV3::CalendarService.new
      calendar_service.authorization = calendar_client
      @calendar_response = calendar_service.list_events(
        'primary', max_results: 5)
      @authorised = true
    rescue
      redirect_to '/auth/google_oauth2'
    end
  end

  def tasks
  end

  def files
    @drive_authorised = false
    begin
      drive_client = Signet::OAuth2::Client.new(access_token: current_user.google_account.fresh_token)
      drive_service = Google::Apis::DriveV3::DriveService.new
      drive_service.authorization = drive_client
      @drive_response = drive_service.list_files
      @drive_authorised = true
    rescue
      redirect_to '/auth/google_oauth2'
    end
  end

  def contacts
  end
end
