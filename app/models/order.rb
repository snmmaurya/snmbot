class Order
  include Mongoid::Document

  field :symbol, type: String
  field :side, type: String
  field :quantity, type: String
  field :price, type: String
  field :timestamp, type: String
  field :order_type, type: String
  field :fee, type: String
end