json.result do
  if params[:page].present?
    json.pagination do
      current = @stores.current_page
      total = @stores.total_pages
      per_page = @stores.limit_value
      json.current current
      json.per_page per_page
      json.pages total
      json.count @stores.total_count
      json.previous (current > 1 ? (current - 1) : nil)
      json.next (current == total ? nil : (current + 1))
    end
  end
  json.stores do
    json.array! @stores do |store|
      json.extract! store, :id, :name, :active, :discarded_at
      json.logo_url Rails.application.routes.url_helpers.url_for(store.logo) if store.logo.attached?
    end
  end
end
