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

  def self.get_events_summary(should_filter_groups, should_include_calendar_ids_of_hyd_team)
    begin_ts = Time.now

    events = get_events(get_calendar_ids_list(true, true))
    # events = get_events_for_calendar_ids(['seshu@indeed.com', 'sasibaratam@indeed.com'])
    end_ts = Time.now

    total_time = end_ts - begin_ts
    # puts "\n\n===\nComputation time: #{total_time.to_i}s\n===\n"
    events
  end

  def self.get_events_gist(should_filter_groups, should_include_calendar_ids_of_hyd_team)
    # get_events_gist_for_calendar_ids(get_calendar_ids_list(true, true))
    get_events_gist_for_calendar_ids(['harish@indeed.com', 'sasibaratam@indeed.com'])
  end

  def self.get_events_gist_headings(events_gist)
    calendar_id, gist = events_gist.first
    gist.keys
  end

  def self.get_events_for_calendar_ids(calendar_ids = [])
    id_to_events_hash = {}
    calendar_ids.each { |calendar_id | id_to_events_hash[calendar_id] = get_events_of_a_calendar_id(calendar_id) }

    id_to_events_hash
  end

  #   {
  #      'seshu@indeed.com': {
  #                             "2016 Q3": 10,
  #                             "2016 Q2": 12,
  #                             "2016 Q1": 13,
  #                             ...
  #                             "2015 Q3": 25
  #                          }
  #   },
  #   {
  #   }
  #
  #
  #   PROPOSED:
  #   {
  #       'seshu@indeed.com': {
  #                               "num_events": 1290,
  #                               "duration_in_business_days" : 23,
  #                               "2016 Q3": {
  #                                             "num_events": 1290,
  #                                             "duration_in_business_days" : 23,
  #                                          },
  #                               "2016 Q2": {
  #                                             "num_events": 1290,
  #                                             "duration_in_business_days" : 23,
  #                                          },
  #
  #
  #
  #
  #
  #
  #
  #                           }
  #   }
  #
  #
  #
  #
  #
  #
  def self.get_events_gist_for_calendar_ids(calendar_ids = [])
    id_to_gist_hash = {}

    calendar_ids.each do |calendar_id|
      id_to_gist_hash[calendar_id] = get_events_gist_of_a_calendar_id(calendar_id)
    end

    id_to_gist_hash
  end

  def self.get_events_gist_of_a_calendar_id(calendar_id)
    years_and_quarters = DateUtils.get_year_quarters_since(2015, 3);

    hash = {}
    years_and_quarters.each do |year_quarter_number_hash|
      year, quarter_number = year_quarter_number_hash.first
      events = get_events_of_a_calendar_id_in_quarter(calendar_id, year, quarter_number)

      year_quarter_as_string = "#{year.to_s} Q#{quarter_number.to_s.upcase}"
      hash[year_quarter_as_string] = events.items.size
    end

    hash
  end

  def self.get_events_of_a_calendar_id_in_quarter(calendar_id, year, quarter_number)
    from = DateUtils.get_quarter_begin_date(year, quarter_number)
    to = DateUtils.get_quarter_end_date(year, quarter_number)

    to = DateUtils.get_quarter_end_date(year, quarter_number)

    events = calendar_service.list_events(calendar_id,
                                          max_results: 2500,
                                          single_events: true,
                                          order_by: 'startTime',
                                          time_min: from,
                                          time_max: to)
  end

  def self.get_events_of_a_calendar_id(calendar_id)
    events = calendar_service.list_events(calendar_id,
                                          max_results: 2500,
                                          single_events: true,
                                          order_by: 'startTime',
                                          # time_min: Time.new(2016,07,01,00,00,00, "+05:30"), # Doesnt work
                                          # time_min: Time.now - 1.month, # Doesnt work
                                          # time_min: "2016-08-01T00:00:00+05:30",
                                          time_min: DateUtils.get_this_quarter_begin_date,
                                          time_max: Time.now.iso8601)

  end

  private

  def self.calendar_service
    CalendarServiceFactory.get_calendar_service
  end

end