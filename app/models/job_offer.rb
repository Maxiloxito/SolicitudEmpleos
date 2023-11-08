class JobOffer < ApplicationRecord
  belongs_to :user
  has_many :replacement_requests, dependent: :destroy
  has_many :applicants, through: :replacement_requests, source: :user

  validates :title, presence: true
  validates :position, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  validates :salary, numericality: { greater_than: 0 }
  validates :location, presence: true
  validates :languages, presence: true
  validate :at_least_one_language
  STATUS_OPTIONS = {
    "Activo" => "active",
    "No Activo" => "inactive"
  }
  
  serialize :languages, Array

  before_validation :clean_languages

  private

  def clean_languages
    self.languages.reject!(&:empty?) if self.languages
  end
  
  def at_least_one_language
    if languages.blank? || languages.empty?
      errors.add(:languages, "debe seleccionar al menos un idioma")
    end
  end
  def self.available
    where(availability: 'Activo')
  end
end
