class CreateJobOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :job_offers do |t|
      t.string :title
      t.string :position
      t.text :description
      t.decimal :salary
      t.string :availability
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
