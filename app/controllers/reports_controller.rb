class ReportsController < ApplicationController

  def show
    @date = parse_date
    @report = Report.new(@date)
  end

  private

    def report_params
      params.require(:report).permit(:date)
    end

    def parse_date
      report_params[:date] ? DateTime.parse(report_params[:date]) :
      DateTime.new(report_params["date(1i)"].to_i, report_params["date(2i)"].to_i,
                  report_params["date(3i)"].to_i, report_params["date(4i)"].to_i,
                  report_params["date(5i)"].to_i)
    end
end
