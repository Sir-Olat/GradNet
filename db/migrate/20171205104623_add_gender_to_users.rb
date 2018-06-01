class AddGenderToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :gender, :integer, default: 0, index: true
    add_column :users, :address, :string
    add_column :users, :date_of_birth, :datetime
    add_column :users, :year_of_graduation, :integer
    add_column :users, :work_place, :string
    add_column :users, :course_studied, :string
    add_column :users, :field_of_expertise, :string
    add_column :users, :bio, :string
    remove_column :users, :image, :text
    remove_column :users, :location, :string
  end
end
