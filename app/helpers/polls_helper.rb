module PollsHelper
  def format_poll_type(type)
    case type
    when 'OPEN'
      return 'Open Answer'
    when 'MULTI'
      return 'Multiple Choice'
    end
    return ''
  end

  def sparkline(data, width=100, height=40, style='', _class='')
    return image_tag(Gchart.sparkline(:data=>data, :width=>width, :height=>height, :bg=>'00000000'), :style=>style, :class=>_class)
  end

  def format_poll_running(poll)
    return poll.running? ? "Live" : "Ended"
  end
  def format_poll_date(date)
    return date.strftime("%m/%d/%y")
  end

  def format_poll_ran_dates(poll)
    if poll.running?
      str = "Running #{time_ago_in_words(poll.start_date, include_seconds = false)} &bull; #{format_poll_date(poll.start_date)} &ndash; now"
    else
      str = "Ran #{distance_of_time_in_words(poll.end_date, poll.start_date)} &bull; #{format_poll_date(poll.start_date)} &ndash;  #{format_poll_date(poll.end_date)}"
    end
    return str
    #str = poll.running? ? "Running " : "Ran "
    #<%= poll.start_date.strftime("%m/%d/%y %I:%M %p")%><

    #             %= time_ago_in_words(poll.start_date, include_seconds = false) %> ago</td>
  end
    

  #formats seconds into days, minutes, etc
  def format_time(secs)
    if secs < 60
      return pluralize(secs.round, 'second')
    elsif secs < 60 * 60
      return pluralize((secs/60).round, 'minute')
    elsif secs < 60 * 60 * 24
      return pluralize((secs/60/60).round, 'hour')
    else
      return pluralize((secs/60/60/24).round, 'day')
    end
  end
  # takes in an array of word, count  array pairs and prints them out in html
  # => [["Paris", 12], ["Wal-mart", 12], ["I", 12], ["buy", 12], ["groceries", 12], ["in", 12], ["Stater", 8], ["Acme", 8], ["or", 8], ["Supreme", 8], ["CVS", 8], ["bros", 8], ["Walgreens", 5]] 
  def html_histogram(histogram)
    result = '' 
    if histogram
      result << "<table>"
      histogram.slice(0,7).each do |h|
        result << "<tr style='font-size:#{0.8+h[1]/20.0}em' class='histogram-pair'><td class='histogram-word'>#{h[0]}</td><td class='histogram-count'>#{h[1]}</td><td style='width:200px;'><div class='histogram-graph' style='width:#{h[1]*8}px;'>&nbsp;</div></td></tr>\n"
      end
      result << "</table>"
    end
    return raw result
  end
end
