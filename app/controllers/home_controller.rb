class HomeController < ApplicationController

  def index
    # @calendars_ids = CalendarUtils.get_calendar_ids_list(true, true)
    # @events_summary = CalendarUtils.get_events_summary(true, true)
    # @events_gist = CalendarUtils.get_events_gist(true, true)

    @events_gist = CalendarUtils.get_events_gist2(true, true, 2015, 3)
    @events_gist_headings = CalendarUtils.get_events_gist_headings(@events_gist)
  end

end