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
      histogram.slice(0,7).each do |h|
        result << "<div style='font-size:#{h[1]/8.0}em' class='histogram-pair'><span class='histogram-word'>#{h[0]}</span><span class='histogram-separator'>:</span><span class='histogram-count'>#{h[1]}</span></div>\n"
      end
    end
    return raw result
  end
end
