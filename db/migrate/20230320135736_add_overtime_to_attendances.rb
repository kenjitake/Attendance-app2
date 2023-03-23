class AddOvertimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_instraction, :string
    add_column :attendances, :instractor, :string
  end
end
