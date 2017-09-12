class CreateSubDomains < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_domains do |t|
      t.string :sname
      t.string :sip
      t.references :domain, foreign_key: true

      t.timestamps
    end
    add_index :sub_domains, [:domain_id, :created_at]
  end
end
