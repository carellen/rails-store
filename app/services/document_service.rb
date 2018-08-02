module DocumentService

  def delete
    goods_entries.delete_all
  end

  def post
    delete
    return if table_rows.empty?
    date_in = date.iso8601(6)
    entries = table_rows.flat_map do |e|
        if instance_of?(ReceiptNote)
          "('#{date_in}',null,#{e.quantity},#{e.price},null,'#{self.class}',#{id},#{e.item_id},'now()','now()')"
        else
          available_items(e.item_id).reduce([ e.quantity, [] ]) do |arr, item|
            break arr unless arr[0] > 0
            [
              arr[0] - item["quantity"],
              arr[1].push(
                          "('#{item["date_in"]}',
                            '#{date_in}',
                             #{item['quantity'] < arr[0] ? -item["quantity"] : -arr[0]},
                             #{item["cost_price"]},#{e.price},
                             '#{self.class}',
                             #{id},#{e.item_id},'now()','now()')"
                           )
            ]
          end[1]
        end
    end
    query = <<-SQL
      INSERT INTO goods_entries
      (date_in, date_out, quantity, cost_price, sale_price, document_type, document_id, item_id, created_at, updated_at)
      VALUES #{entries.join(',')}
      RETURNING id
    SQL
    ActiveRecord::Base.connection.execute(query)
  end

    private

      def available_items(item_id)
        query = <<-SQL
          SELECT t.*
          FROM (SELECT date_in, cost_price, sum(quantity) quantity
                FROM goods_entries
                WHERE item_id = #{item_id}
                GROUP BY date_in, cost_price
                ORDER BY date_in) t
          WHERE t.quantity > 0
        SQL
        ActiveRecord::Base.connection.execute(query).to_a
      end
end
