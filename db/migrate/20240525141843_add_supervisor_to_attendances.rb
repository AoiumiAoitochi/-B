class AddSupervisorToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :supervisor, :string
  end
end
