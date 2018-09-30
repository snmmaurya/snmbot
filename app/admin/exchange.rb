ActiveAdmin.register Exchange do
  menu parent: "Master"

  permit_params :title, :ecode, :status

  index do
    selectable_column
    column :title
    column :ecode
    column :status
    column :created_at
    actions
  end

  filter :ecode

  form do |f|
    f.inputs do
      f.input :title
      f.input :ecode
      f.input :status, as: :boolean
    end
    f.actions
  end

end