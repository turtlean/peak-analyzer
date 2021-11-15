class Sample < ApplicationRecord
  belongs_to :serie
  validates :value, presence: true

  scope :by_serie, -> (serie_id) { joins(:serie).where(serie: {id: serie_id}) }
  scope :by_serie_and_window, -> (serie_id, window) { joins(:serie).where(serie: {id: serie_id}).order('samples.id DESC').limit(window) }
end
