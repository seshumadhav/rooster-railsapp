class HomeController < ApplicationController

  def index
    @calendars_ids = CalendarUtils.get_calendar_list
  end

end