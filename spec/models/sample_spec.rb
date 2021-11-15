require 'rails_helper'

RSpec.describe Sample, type: :model do
  let(:first_serie) { Serie.create! }
  let(:second_serie) { Serie.create! }

  it "fetches samples by serie and window" do
      Sample.create!({serie_id: first_serie.id, value: 10})
      Sample.create!({serie_id: second_serie.id, value: 20})

      samples = Sample.by_serie(first_serie.id)

      assert samples.length == 1
      assert samples[0].serie_id == first_serie.id && samples[0].value == 10
  end

  it "fetches samples by serie and window" do
    Sample.create!([
      {serie_id: first_serie.id, value: 10},
      {serie_id: first_serie.id, value: 20},
      {serie_id: first_serie.id, value: 30},
      {serie_id: first_serie.id, value: 40},
      {serie_id: first_serie.id, value: 50},
    ])

    samples = Sample.by_serie_and_window(first_serie.id, 3)

    assert samples.length == 3
    assert (samples.map &:value) == [50, 40, 30]
  end
end
