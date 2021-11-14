class Sample < ApplicationRecord
  belongs_to :serie
  validates :value, presence: true

  scope :by_serie, -> (serie_id) { joins(:serie).where(serie: {id: serie_id}) }
end
