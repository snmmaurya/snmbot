ActiveAdmin.register Market do
  menu parent: "Master"

  permit_params :title, :exchange_id

  index do
    selectable_column
    column :title
    column :status
    column :exchange
    column :created_at
    actions
  end

  filter :ecode

  form do |f|
    f.inputs do
      f.input :exchange_id, as: :select, collection: Exchange.all.map{|ex| [ex.title, ex.id]}, prompt: 'Select Exchange'
      f.input :title
      f.input :status, as: :boolean
    end
    f.actions
  end

end