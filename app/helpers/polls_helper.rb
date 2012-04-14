module PollsHelper
  def to_csv
    csv = ""
    self.first.responses.map { |resp| [ resp.poll_id, resp.created_at, resp.from, resp.response ] }.each do |r|
      csv += r.to_csv
    end
    return csv
  end
end
