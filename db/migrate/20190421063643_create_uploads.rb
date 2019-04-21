class CreateUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :uploads do |t|
      t.string :title
      t.string :description
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
