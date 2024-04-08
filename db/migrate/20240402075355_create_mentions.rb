class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.integer :source_id, null: false, index: true
      t.integer :destination_id, null: false, index: true

      t.timestamps
    end
    add_foreign_key :mentions, :reports, column: :source_id
    add_foreign_key :mentions, :reports, column: :destination_id
    add_index :mentions, %i[source_id destination_id], unique: true
  end
end
