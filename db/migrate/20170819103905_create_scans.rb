class CreateScans < ActiveRecord::Migration[5.0]
  def change
    create_table :scans do |t|
      t.string :title
      t.string :target
      t.integer :status, default: 0
      t.string :jid

      t.timestamps
    end
  end
end
