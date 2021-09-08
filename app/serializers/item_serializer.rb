class ItemSerializer
  include FastJsonapi::ObjectSerializer
  set_type :item
  attributes :name, :description, :unit_price, :merchant_id
end
