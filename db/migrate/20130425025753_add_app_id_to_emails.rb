class AddAppIdToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :app_id, :integer
  end
end
