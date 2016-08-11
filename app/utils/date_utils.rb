class DateUtils

  QUARTER_END_DATES = {
      1 => 31,
      2 => 30,
      3 => 30,
      4 => 31
  }

  DAYS_IN_QUARTER = {
      1 => (23+20+23),
      2 => (22+23+22),
      3 => (23+23+22),
      4 => (23+22+23)
  }

  # Returns hash like below
  # [ {2015: 3}, {2015: 4}, .. , {2016: 3}]
  def self.get_year_quarters_since(year, quarter_number)
    year_quarters_list = []

    y = get_this_year_number
    q = get_this_quarter_number

    while y >= year
      q = ((y == get_this_year_number) ? get_this_quarter_number : 4)
      min_q = (y == year) ? quarter_number : 1
      while q >= min_q
        year_quarter_tuple = {}
        year_quarter_tuple[y] = q
        year_quarters_list << year_quarter_tuple
        q = q - 1
      end
      y = y - 1
    end

    year_quarters_list
  end

  def self.get_this_quarter_number
    get_quarter_number(Time.now())
  end

  def self.get_this_year_number
    Time.now().year
  end

  def self.get_quarter_number(date)
    month = date.month

    # quarter_number = case month
    #                    when (month >= 1 && month <= 3)
    #                      1
    #                    when (month >= 4 && month <= 6)
    #                      2
    #                    when (month >= 7 && month <= 9)
    #                      3
    #                    when (month >= 10 && month <= 12)
    #                      4
    # end

    if month >= 10
      quarter_number = 4
    elsif month >= 7
      quarter_number = 3
    elsif month >= 4
      quarter_number = 2
    else
      quarter_number = 1
    end

   quarter_number
  end

  def self.get_this_quarter_begin_date
    today = Time.now()

    year = today.year
    quarter_number = get_quarter_number(today)

    quarter_begin_date(year, quarter_number)
  end

  def self.get_quarter_begin_date(year, quarter_number)
    month = get_start_month_of_quarter(quarter_number)
    month_value = prepend_zero(month)

    "#{year}-#{month_value}-01T00:00:00+05:30"
  end

  def self.get_quarter_end_date(year, quarter_number)
    quarter_end_month =  quarter_number * 3

    "#{year}-#{prepend_zero(quarter_end_month)}-#{QUARTER_END_DATES[quarter_number]}T00:00:00+05:30"
  end

  def self.get_start_month_of_quarter(quarter_number)
    case quarter_number
      when 1
        1
      when 2
        4
      when 3
        7
      when 4
        10
    end
  end

  def self.prepend_zero(integer)
    (integer < 10) ? "0#{integer.to_s}" : "#{integer.to_s}"
  end

end