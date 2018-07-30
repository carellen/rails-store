class Report
  include ReportService

  attr_accessor :date, :data

  def initialize(date = DateTime.now)
    @date = date
    @data = ReportService.calculate_for(date)
  end
end
