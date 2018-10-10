class Currency < Concerns::OdmWrapper
  STATUSES = {"0"=>"active", "1"=>"inactive"}

  field :title, type: String, default: ""
  field :ccode, type: String, default: ""
  field :status, type: Integer, default: 0

end