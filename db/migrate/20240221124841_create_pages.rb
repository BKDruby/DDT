class CreatePages < ActiveRecord::Migration[7.1]
  def change
    create_table :pages do |t|
      t.string :url
      t.index :url
      t.timestamps
    end
  end
end
