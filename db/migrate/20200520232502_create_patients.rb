class CreatePatients < ActiveRecord::Migration[6.0]
  def change
    create_table :patients do |t|

      t.timestamps
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.datetime :birthdate, null: false
      t.string :sex, null: false
    end
  end
end
