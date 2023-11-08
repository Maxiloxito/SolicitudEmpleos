class AddLanguagesToJobOffers < ActiveRecord::Migration[7.0]
  def change
    add_column :job_offers, :languages, :text
  end
end
