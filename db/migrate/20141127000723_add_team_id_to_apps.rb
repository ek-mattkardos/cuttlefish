class AddTeamIdToApps < ActiveRecord::Migration
  def change
    add_reference :apps, :team, index: true, null: false, default: 1
    reversible do |dir|
      dir.up do
        change_column_default :apps, :team_id, nil
      end

      dir.down do
        change_column_default :apps, :team_id, 1
      end
    end
  end
end
