class GistUtils

  NUM_EVENTS = 'Total Events'
  NUM_EVENTS_ATTENDED = 'Attended'
  DAYS_SPENT_IN_MEETINGS = 'Days In Meetings'
  DAYS_IN_INDEED = 'Days@Indeed'
  PERCENT_TIME_IN_MEETINGS = '% Time In Meetings'
  NUM_DAYS_IN_QUARTER = 'Days In Quarter'
  DETAILS = 'Details'


  # INPUT:
  # {"harish@indeed.com"=>
  #      {"2016 Q3"=>
  #           {"Total Events"=>16,
  #            "Attended Events"=>16,
  #            "Days Spent In Meetings"=>2.13,
  #            "Days in Quarter"=>68,
  #            "Percentage time Spent In Meetings"=>3.13},
  #       "2016 Q2"=>
  #           {"Total Events"=>6,
  #            "Attended Events"=>6,
  #            "Days Spent In Meetings"=>0.81,
  #            "Days in Quarter"=>67,
  #            "Percentage time Spent In Meetings"=>1.21},
  #       "2016 Q1"=>
  #           {"Total Events"=>0,
  #            "Attended Events"=>0,
  #            "Days Spent In Meetings"=>0.0,
  #            "Days in Quarter"=>0,
  #            "Percentage time Spent In Meetings"=>0},
  #       "2015 Q4"=>
  #           {"Total Events"=>0,
  #            "Attended Events"=>0,
  #            "Days Spent In Meetings"=>0.0,
  #            "Days in Quarter"=>0,
  #            "Percentage time Spent In Meetings"=>0},
  #       "2015 Q3"=>
  #           {"Total Events"=>0,
  #            "Attended Events"=>0,
  #            "Days Spent In Meetings"=>0.0,
  #            "Days in Quarter"=>0,
  #            "Percentage time Spent In Meetings"=>0},
  #       "Total Events"=>22,
  #       "Attended Events"=>22,
  #       "Days Spent In Meetings"=>3,
  #       "Days in Indeed"=>135,
  #       "Percentage time Spent In Meetings"=>2.18}
  # }
  def self.split(gist)
    base = {}
    more = {}

    gist.each do |calendar_id, data|
      hash = {}
      more_hash = {}
      # In data, keys are your quarters + summaries
      # values are info about each quarter
      data.map do |k, v|
        value_hash = {}
        more_value_hash = {}

        if v.class == Hash
          hash[k] = v[PERCENT_TIME_IN_MEETINGS]
          more_hash[k] = v
        else
          hash[k] = v
        end
      end

      base[calendar_id] = hash
      more[calendar_id] = more_hash
    end

    return base, more
  end

  def self.print(hash)
    return '' if hash.blank?

    string = ''

    hash.each do |k, v|
      string += "#{k}: #{v}\n"
    end

    string
  end

  def self.is_quarter_heading(heading)
    heading.start_with?('2') || heading.start_with?('%')
  end


end