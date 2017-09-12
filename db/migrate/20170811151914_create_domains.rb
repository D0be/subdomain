class CreateDomains < ActiveRecord::Migration[5.0]
  def change
    create_table :domains do |t|
      t.string :dtitle
      t.string :dname
      t.string :dip

      t.timestamps
    end
  end
end
