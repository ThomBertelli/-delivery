json.extract! @store, :id, :name, :created_at, :updated_at, :user_id, :active, :discarded_at

if @store.logo.attached?
  json.logo_url Rails.application.routes.url_helpers.url_for(@store.logo)
else
  json.logo_url nil
end
