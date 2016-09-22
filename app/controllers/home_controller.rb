class HomeController < ApplicationController

  def index
    @events_gist = CalendarUtils.get_events_gist(true, true, 2016, 1, true)
    @events_gist_headings = CalendarUtils.get_events_gist_headings(@events_gist)

    @base, @more = GistUtils.split(@events_gist)
  end

end