class CalendarUtils

  def self.get_calendar_list
    calendar_list = CalendarServiceFactory.get_calendar_service.list_calendar_lists

    calendars = []
    calendars = calendar_list.items.collect {|calendar_item| calendar_item.id}

    calendars
  end

end