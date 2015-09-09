ActiveAdmin.register User do
  menu priority: 2

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :email
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

  index do
    column :id
    column :name
    column :email
    column :provider
    column :admin
    actions
  end

  form do |f|
    f.inputs "User Details" do
        f.input :name
        f.input :email
    end
    f.button :Submit
  end

end
