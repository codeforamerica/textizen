module PollsHelper
  def format_poll_type(type)
    case type
    when 'OPEN'
      return 'Open'
    when 'MULTI'
      return 'Multiple Choice'
    end
    return ''
  end
end
