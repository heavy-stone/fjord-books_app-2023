class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true, type: :bigint
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
