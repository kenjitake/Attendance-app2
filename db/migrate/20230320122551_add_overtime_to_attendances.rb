class AddOvertimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_instruction, :string
    add_column :attendances, :instructor, :string
    references :user, foreign_key: true
  end
end
