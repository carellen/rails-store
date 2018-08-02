class SaleReport
  include ReportService

  attr_accessor :date_start, :date_end, :data

  def initialize(date_start = Time.now, date_end = Time.now)
    @date_start = date_start
    @date_end = date_end
    @data = ReportService.sold_items(date_start, date_end)
  end
end
