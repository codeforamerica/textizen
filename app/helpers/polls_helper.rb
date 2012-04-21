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
end
