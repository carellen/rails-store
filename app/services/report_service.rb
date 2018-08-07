module ReportService
  Item = Struct.new(:name, :date, :price, :quantity)

  class << self
    def calculate_for(report_date = DateTime.now)
      query = <<-SQL
        SELECT t.*
        FROM (SELECT item_id, date_in, price, sum(quantity) quantity
                          FROM goods_entries
                          WHERE date_in <= '#{report_date}'
													AND date_out <= '#{report_date}'
													OR date_out IS NULL
                          GROUP BY item_id, date_in, price
                          ORDER BY item_id, date_in) t
        WHERE quantity > 0
      SQL
      items = ActiveRecord::Base.connection.execute(query)
      items.map { |i| Item.new(i["item_id"], i["date_in"], i["price"], i["quantity"]) }
    end

    def available_quantity_for(item_id)
      income_quantity = Income.where(item_id: item_id).sum(:quantity)
      outcome_quantity = Outcome.where(item_id: item_id).sum(:quantity)
      income_quantity - outcome_quantity
    end

    def available_items
      income_items = Income.select(:item_id, :quantity)
        .reduce({}) do |h, inc|
          h.merge!({ inc.item_id => inc.quantity }) { |k, old_v, new_v| old_v + new_v }
        end
      outcome_items = Outcome.select(:item_id, :quantity)
        .reduce({}) do |h, out|
          h.merge!({ out.item_id => out.quantity }) { |k, old_v, new_v| old_v + new_v }
        end
      income_items.merge!(outcome_items) {|k,old_v, new_v| old_v - new_v}.reject{ |k,v| v <= 0 }
    end
  end
end
