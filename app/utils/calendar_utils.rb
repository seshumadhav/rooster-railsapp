class CalendarUtils

  def self.get_calendar_ids_list(should_filter_groups, should_include_calendar_ids_of_hyd_team)
    calendar_list = calendar_service.list_calendar_lists
    calendar_ids_list = calendar_list.items.collect {|calendar_item| calendar_item.id}

    calendar_ids_to_return = should_filter_groups ? filter_group_calendars(calendar_ids_list) : calendar_ids_list
    calendar_ids_to_return = calendar_ids_to_return + YAML.load_file('config/calendar_ids_of_hyd_team.yml') if should_include_calendar_ids_of_hyd_team

    calendar_ids_to_return
  end

  def self.filter_group_calendars(calendar_ids)
    calendar_ids.select {|id| !id.end_with?('group.calendar.google.com') && !id.end_with?('group.v.calendar.google.com')}
  end

  def self.get_events(calendar_id)
    events = calendar_service.list_events(calendar_id,
                                          max_results: 2500,
                                          single_events: true,
                                          order_by: 'startTime',
                                          # time_min: Time.new(2016,07,01,00,00,00, "+05:30"), # Doesnt work
                                          # time_min: Time.now - 1.month, # Doesnt work
                                          time_max: Time.now.iso8601)

  end

  private

  def self.calendar_service
    CalendarServiceFactory.get_calendar_service
  end

end