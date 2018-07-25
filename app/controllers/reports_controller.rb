class ReportsController < ApplicationController
  include Report

  def show
    @report = Report.calculate_for(DateTime.now)
  end

  private

    def report_params
      params.require(:report).permit(:date)
    end
end
