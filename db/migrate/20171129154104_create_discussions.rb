class CreateDiscussions < ActiveRecord::Migration[5.1]
  def change
    create_table :discussions do |t|
      t.text :body
      t.string :slug

      t.timestamps
    end
    add_index :discussions, :slug, unique: true
  end
end
