class HomeController < ApplicationController

  def index
    @events_gist = CalendarUtils.get_events_gist(true, true, 2015, 3)
    @events_gist_headings = CalendarUtils.get_events_gist_headings(@events_gist)
  end

end