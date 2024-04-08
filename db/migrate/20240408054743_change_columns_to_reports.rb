class ChangeColumnsToReports < ActiveRecord::Migration[7.0]
  def change
    change_column :reports, :title, :string, null: false
    change_column :reports, :content, :text, null: false
  end
end
