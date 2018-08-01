class DocumentService
  def initialize(document)
    @document = document
  end

  def delete
    @document.goods_entries.delete_all
  end

  def post
    delete
    return if @document.table_rows.empty?
    date = @document.date.iso8601(6)
    entries = @document.table_rows.flat_map do |e|
        if @document.instance_of?(ReceiptNote)
          "('#{date}',null,#{e.quantity},#{e.price},null,
          '#{@document.class}',#{@document.id},#{e.item_id},'now()','now()')"
        else
          query = <<-SQL
            SELECT t.*
            FROM (SELECT date_in, cost_price, sum(quantity) quantity
                  FROM goods_entries
                  WHERE item_id = #{e.item_id}
                  GROUP BY date_in, cost_price
                  ORDER BY date_in) t
            WHERE t.quantity > 0
          SQL
          available_items = ActiveRecord::Base.connection.execute(query).to_a
          items_q = e.quantity
          entries = []
          available_items.each do |item|
            if item['quantity'] < items_q
              items_q -= item["quantity"]
              entries.push("('#{item["date_in"]}','#{date}',#{-item["quantity"]},
              #{item["cost_price"]},#{e.price},'#{@document.class}',
              #{@document.id},#{e.item_id},'now()','now()')")
            else
              entries.push("('#{item["date_in"]}','#{date}',#{-items_q},
              #{item["cost_price"]},#{e.price},'#{@document.class}',
              #{@document.id},#{e.item_id},'now()','now()')")
              break
            end
          end
          entries
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
end
