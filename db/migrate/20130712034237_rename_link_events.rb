class RenameLinkEvents < ActiveRecord::Migration
  def change
    rename_table :link_events, :click_events
  end
end
