module ReportService
  Item = Struct.new(:name, :date, :price, :quantity)

  class << self
    # def calculate_for(date)
    #
    # end

    def calculate_for(date)
      inc = Income.joins(:receipt_note)
        .where("receipt_notes.date <= ?", date)
        .includes(:item, :receipt_note)
        .group_by { |income| [income.item_name, income.in_date, income.price] }
        .sort_by { |k,v| [k[0], k[1]] }
      out = Outcome.joins(:delivery_note)
        .where("delivery_notes.date <= ?", date)
        .includes(:item, :delivery_note)
        .group_by { |outcome| [outcome.item_name] }

      out = out.inject({}) do |s, outcome|
        s.merge({ outcome[0][0] => outcome[1].reduce(0) { |sum, o| sum += o.quantity } })
      end
      out.each do |k,v|
        out = v
        inc.each do |arr|
          if k == arr[0][0]
            if out > arr[1][0].quantity
              out -= arr[1][0].quantity
              arr[1][0].quantity = 0
            else
              arr[1][0].quantity -= out
              break
            end
          end
        end
      end
      inc.reject {|i| i[1][0].quantity <= 0}.map do |i|
        Item.new(
          i[0][0],
          i[0][1],
          i[0][2],
          i[1].inject(0) { |s,income| s += income.quantity }
        )
      end.sort_by { |i| [i.name, i.date, i.price] }
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
