class Report
  include ReportService

  attr_accessor :date, :data

  def initialize(date = Time.now)
    @date = date
    @data = ReportService.items_in_store(date)
  end
end
