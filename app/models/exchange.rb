class Exchange < Concerns::OdmWrapper
  STATUSES = {"0"=>"active", "1"=>"inactive"}
  field :title, type: String, default: ""
  field :ecode, type: String, default: ""
  field :status, type: Integer, default: 0

  has_many :markets

  scope :active, -> {where("status = 0")}
end



