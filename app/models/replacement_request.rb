class ReplacementRequest < ApplicationRecord
  belongs_to :user
  belongs_to :job_offer
end
