json.result do
  if params[:page].present?
    json.pagination do
      current = @orders.current_page
      total = @orders.total_pages
      per_page = @orders.limit_value
      json.current current
      json.per_page per_page
      json.pages total
      json.count @orders.total_count
      json.previous (current > 1 ? (current - 1) : nil)
      json.next (current == total ? nil : (current + 1))
    end
  end

  json.orders do
    json.array! @orders do |order|
      json.id order.id
      json.state order.state
      json.order_items order.order_items do |order_item|
        json.amount order_item.amount
        json.price order_item.price
        json.product do
          json.id order_item.product.id
          json.title order_item.product.title
          end
        end
      end
    end
end
