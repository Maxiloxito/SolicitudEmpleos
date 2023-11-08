class AddLanguageToJobOffer < ActiveRecord::Migration[7.0]
  def change
    add_column :job_offers, :language, :string
  end
end
