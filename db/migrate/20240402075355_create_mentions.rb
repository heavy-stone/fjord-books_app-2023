class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.references :source, null: false, foreign_key: { to_table: :reports }
      t.references :destination, null: false, foreign_key: { to_table: :reports }

      t.timestamps
    end
    add_index :mentions, %i[source_id destination_id], unique: true
  end
end
