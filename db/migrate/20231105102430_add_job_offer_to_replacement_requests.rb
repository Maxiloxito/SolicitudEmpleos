class AddJobOfferToReplacementRequests < ActiveRecord::Migration[7.0]
  def change
    add_reference :replacement_requests, :job_offer, null: false, foreign_key: true
  end
end
