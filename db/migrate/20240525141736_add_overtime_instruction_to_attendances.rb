class AddOvertimeInstructionToAttendances < ActiveRecord::Migration[7.1]
  def change
    add_column :attendances, :overtime_instruction, :string
  end
end
