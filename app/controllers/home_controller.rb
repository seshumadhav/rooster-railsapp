class HomeController < ApplicationController

  def index
    start = DateTime.now

    @events_gist = CalendarUtils.get_events_gist(true, true, 2015, 3, true)
    @events_gist_headings = CalendarUtils.get_events_gist_headings(@events_gist)

    @base, @more = GistUtils.split(@events_gist)

    complete = DateTime.now
    puts "Time taken: #{((complete - start) * 24 * 60 * 60).to_i} seconds"
  end

end