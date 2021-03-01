class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :fullname
      t.string :surname
      t.string :email
      t.string :cpf
      t.string :phone
      t.string :password_digest

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
