module ReportService
  Item = Struct.new(:name, :date, :cost_price, :quantity)
  Sale = Struct.new(:name, :quantity, :cost_price, :sale_price, :profit)

  class << self
    def items_in_store(report_date = Time.now)
      query = <<-SQL
        SELECT t.*
        FROM (SELECT item_id, date_in, cost_price, sum(quantity) quantity
                          FROM goods_entries
                          WHERE date_in <= '#{report_date}'
													AND date_out <= '#{report_date}'
													OR date_out IS NULL
                          GROUP BY item_id, date_in, cost_price
                          ORDER BY item_id, date_in) t
        WHERE quantity > 0
      SQL
      items = ActiveRecord::Base.connection.execute(query)
      items.map { |i| Item.new(i["item_id"], Time.zone.parse(i["date_in"]), i["cost_price"], i["quantity"]) }
    end

    def sold_items(date_start = Time.now, date_end = Time.now)
      query = <<-SQL
        SELECT item_id, abs(sum(quantity)) quantity, cost_price, sale_price
        FROM goods_entries
        WHERE document_type = 'DeliveryNote'
        AND date_out BETWEEN '#{date_start}' AND '#{date_end}'
        GROUP BY item_id, cost_price, sale_price
        ORDER BY item_id
      SQL
      items = ActiveRecord::Base.connection.execute(query).to_a
      items  = items.group_by { |i| i['item_id']}.map do |k, v|
          Sale.new(k, *v.reduce(Hash.new(0)) { |h, el|
            h[:quantity] += el['quantity']
            h[:cost_price] += el['quantity']*BigDecimal(el['cost_price'])
            h[:sale_price] += el['quantity']*BigDecimal(el['sale_price'])
            h[:profit] += el['quantity']*BigDecimal(el['sale_price']) - el['quantity']*BigDecimal(el['cost_price'])
            h
          }.values)
      end
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
