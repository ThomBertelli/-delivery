json.extract! @product, :id, :store_id, :title, :price, :created_at, :updated_at
json.store do
  json.extract! @product.store, :id, :name
end
