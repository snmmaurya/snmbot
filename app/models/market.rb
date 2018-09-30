class Market < Concerns::OdmWrapper
  STATUSES = {"0"=>"active", "1"=>"inactive"}
  field :title, type: String, default: ""
  # field :exchange_id, type: String, default: ""
  field :ecode, type: String, default: ""
  field :status, type: Integer, default: 0
  field :quantity_to_sell, type: BigDecimal, default: 0.0
  field :quantity_to_buy, type: BigDecimal, default: 0.0

  belongs_to :exchange


  before_create :seed_before_create

  def seed_before_create
    self.ecode = self.exchange.ecode
  end
end