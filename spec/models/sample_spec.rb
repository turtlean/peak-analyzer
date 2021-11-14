require 'rails_helper'

RSpec.describe Sample, type: :model do
  context "by_serie scope" do
    let(:first_serie) { Serie.create! }
    let(:second_serie) { Serie.create! }

    it "fetches scoped samples" do
      Sample.create!({serie_id: first_serie.id, value: 10})
      Sample.create!({serie_id: second_serie.id, value: 20})

      samples = Sample.by_serie(first_serie.id)

      assert samples.length == 1
      assert samples[0].serie_id == first_serie.id && samples[0].value == 10
    end
  end
end
