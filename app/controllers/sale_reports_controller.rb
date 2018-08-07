class SaleReportsController < ApplicationController

  def show
    @date_start = parse_date('date_start')
    @date_end = parse_date('date_end')
    @report = SaleReport.new(@date_start, @date_end)
  end

  private

    def report_params
      params.require(:report).permit(:date_start, :date_end)
    end

    def parse_date(date)
      report_params[date.to_sym] ? Time.parse(report_params[date.to_sym]) :
      Time.new(report_params["#{date}(1i)"].to_i, report_params["#{date}(2i)"].to_i,
                  report_params["#{date}(3i)"].to_i, report_params["#{date}(4i)"].to_i,
                  report_params["#{date}(5i)"].to_i)
    end
end
