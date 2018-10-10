class DcxOrderBook
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUSES = {"0"=>"active", "1"=>"inactive"}
  SIDES = {"0"=>"bid", "1"=>"ask"}

  field :mcode, type: String, default: ""
  field :data, :type => Hash, default: {}

  index({ mcode: 1}, {name: "dcx_order_book_mcode_index" })
end