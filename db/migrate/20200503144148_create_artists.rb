class CreateArtists < ActiveRecord::Migration[6.0]
  def change
    create_table :artists do |t|
      t.string :name
      t.integer :age
      t.integer :gender
      t.date :birth

      t.timestamps
    end
  end
end
