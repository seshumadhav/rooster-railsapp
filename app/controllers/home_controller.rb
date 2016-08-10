class HomeController < ApplicationController

  def index
    @calendars_ids = CalendarUtils.get_calendar_ids_list(true)
  end

end