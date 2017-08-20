ActiveAdmin.register User do

	permit_params :visible
	actions :all, :except => [:new]

	index do
	  selectable_column
	  column :email
	  column :current_sign_in_at
	  column :last_sign_in_at
	  column :current_sign_in_ip
	  column :last_sign_in_ip
	  column :time_zone
	  column :visible
	  actions
	end

	form do |f|
    f.inputs "Users Details" do
      f.input :visible
    end
    f.actions
  end

	filter :email
	filter :time_zone


end
