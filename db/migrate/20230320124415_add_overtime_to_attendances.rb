class AddOvertimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_instraction, :string
    add_column :attendances, :instractor, :string
    add_reference :attendances, :user, foreign_key: true
  end
end
