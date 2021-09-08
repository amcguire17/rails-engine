class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  set_type :merchant
  attributes :name
end
