class Currency
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUSES = {"0"=>"active", "1"=>"inactive"}

  field :title, type: String, default: ""
  field :ccode, type: String, default: ""
  field :status, type: Integer, default: 0

end