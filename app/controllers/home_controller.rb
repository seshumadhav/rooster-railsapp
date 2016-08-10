class HomeController < ApplicationController

  def index
    # @calendars_ids = CalendarUtils.get_calendar_ids_list(true, true)
    @events_summary = CalendarUtils.get_events_summary(true, true)
  end

end