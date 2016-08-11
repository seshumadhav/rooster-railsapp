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

  def self.get_events_gist2(should_filter_groups, should_include_calendar_ids_of_hyd_team, since_year, since_quarter_number)
    # get_events_gist_for_calendar_ids2(get_calendar_ids_list(true, true), since_year, since_quarter_number)
    get_events_gist_for_calendar_ids2(['harish@indeed.com', 'sasibaratam@indeed.com'], since_year, since_quarter_number)
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
  def self.get_events_gist_for_calendar_ids(calendar_ids = [])
    id_to_gist_hash = {}

    calendar_ids.each do |calendar_id|
      id_to_gist_hash[calendar_id] = get_events_gist_of_a_calendar_id(calendar_id)
    end

    id_to_gist_hash
  end

  def self.get_events_gist_for_calendar_ids2(calendar_ids = [], since_year, since_quarter_number)
    id_to_gist_hash = {}

    calendar_ids.each do |calendar_id|
      id_to_gist_hash[calendar_id] = get_events_gist_of_a_calendar_id2(calendar_id, since_year, since_quarter_number)
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
  #                           }
  #   }
  def self.get_events_gist_of_a_calendar_id2(calendar_id, since_year, since_quarter_number)
    years_and_quarters = DateUtils.get_year_quarters_since(since_year, since_quarter_number)

    quarter_gist = {}
    num_events = 0
    num_events_attended = 0
    duration_in_business_days = 0
    num_days_so_far = 0
    hash = {}

    years_and_quarters.each do |year_quarter_number_hash|
      year, quarter_number = year_quarter_number_hash.first
      events = get_events_of_a_calendar_id_in_quarter(calendar_id, year, quarter_number)

      year_quarter_as_string = get_heading(year, quarter_number)
      quarter_gist = get_quarter_gist(calendar_id, events, year, quarter_number)

      hash[year_quarter_as_string] = quarter_gist

      num_events += quarter_gist['num_events']
      num_events_attended += quarter_gist['num_events_attended']
      duration_in_business_days += quarter_gist['duration_in_business_days']
      num_days_so_far += quarter_gist['num_days_in_quarter']
    end

    hash['num_events'] = num_events
    hash['num_events_attended'] = num_events_attended
    hash['duration_in_business_days'] = duration_in_business_days
    hash['num_days_so_far'] = num_days_so_far
    hash['percent_time_in_meetings'] = (duration_in_business_days.to_f * 100 / num_days_so_far).round(2)

    hash
  end

  def self.get_events_gist_of_a_calendar_id2_headings(since_year, since_quarter_number)
    years_and_quarters = DateUtils.get_year_quarters_since(since_year, since_quarter_number)

    headings = []
    years_and_quarters.each do |year_quarter_number_hash|
      year, quarter_number = year_quarter_number_hash.first
      headings << get_heading(year, quarter_number)
    end

    headings
  end

  def self.get_events_gist_headings(gist)
    calendar_id, hash = gist.first
    hash.keys
  end

  def self.get_heading(year, quarter)
    return "#{year.to_s} Q#{quarter.to_s.upcase}"
  end

  def self.get_quarter_gist(calendar_id, events, year, quarter_number)
    gist = {}

    attended_events = filter_declined_events(calendar_id, events)
    puts "All: #{events.items.size}"
    puts "Filtered: #{attended_events.size}"

    gist['num_events'] = events.items.size
    gist['num_events_attended'] = attended_events.size
    gist['duration_in_business_days'] = get_duration_of_events_in_business_days(attended_events)
    gist['num_days_in_quarter'] = events.items.size == 0 ? 0 : DateUtils::DAYS_IN_QUARTER[quarter_number]
    gist['percent_time_in_meetings'] = events.items.size == 0 ? 0 : (gist['duration_in_business_days'].to_f * 100 / gist['num_days_in_quarter']).round(2)

    gist
  end

  def self.filter_declined_events(calendar_id, events)
    filtered = []

    events.items.each do |event|
      puts "Event: #{event}"
      filtered << event unless declined_event(calendar_id, event)
    end

    filtered
  end

  def self.declined_event(calendar_id, event)
    return false if event.attendees.blank?

    event.attendees.each do |attendee|
      puts "Event.attendee => #{attendee.id}\tStatus: #{attendee.response_status}"

      puts "declined_event: Response_status: (#{attendeed.id}, #{attendee.response_status}"
      if attendee.id == calendar_id && attendee.response_status == 'declined'
        return true
      end
    end

    return false
  end

  def self.get_duration_of_events_in_business_days(events)
    duration_in_secs = get_duration_of_events_in_seconds(events)
    duration_in_days = (duration_in_secs.to_f / (60 * 60 * 8)).round(2)
    puts "get_duration_of_events_in_business_days: #{duration_in_days}\tin_seconds: #{duration_in_secs}"

    duration_in_days
  end


  def self.get_duration_of_events_in_seconds(events)
    duration_in_secs = 0

    events.each do |event|
      duration_in_secs += get_duration_of_event_in_seconds(event)
    end

    duration_in_secs
  end

  def self.get_duration_of_event_in_seconds(event)
    puts "Event: #{event.start.date_time} to #{event.end.date_time}\nDelta: #{event.end.date_time.to_i - event.start.date_time.to_i}"

    event.end.date_time.to_i - event.start.date_time.to_i
  end

  def self.get_events_of_a_calendar_id_in_quarter(calendar_id, year, quarter_number)
    from = DateUtils.get_quarter_begin_date(year, quarter_number)
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