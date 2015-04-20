class AddDeliveryStatusToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :delivery_status, :string
    Email.reset_column_information
    Email.all.each do |email|
      email.update_status!
    end
  end
end
