class User < ApplicationRecord
    enum role: { employee: 'employee', employer: 'employer' }
    has_secure_password
    has_one_attached :resume
    has_one_attached :profile_picture
    validates :first_name, :last_name, :email, :location, :contact, :engineering_type, presence: true
    validates :experience, numericality: { greater_than_or_equal_to: 0 }
    validates :languages, presence: true
    
    validates :email, uniqueness: true

    has_many :replacement_requests
    has_many :job_offers
    attr_accessor :score


    serialize :languages, Array

    before_validation :clean_languages

    private

    def clean_languages
    self.languages.reject!(&:empty?)
    end

    def language
    end
end
  