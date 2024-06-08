json.extract! @product, :id, :store_id, :title, :price, :created_at, :updated_at, :active, :discarted_at
json.store do
  json.extract! @product.store, :id, :name
end
