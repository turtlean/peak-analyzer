require 'rails_helper'

RSpec.describe Api::SamplesController, type: :controller do
  context "index" do
    let(:serie) { Serie.create! }

    it "fetches samples when there isn't any" do
      get :index, params: {series_id: 1}

      json_response = JSON.parse(response.body)
      assert json_response == []
    end

    it "fetches samples for serie" do
      s = Serie.create!
      Sample.create!({serie_id: serie.id, value: 1.0})

      get :index, params: {series_id: serie.id}

      json_response = JSON.parse(response.body)
      assert json_response.length == 1
    end
  end

  context "create" do
    let(:serie) { Serie.create! }

    it "creates new serie" do
      prev_count = Sample.all.length

      post :create, params: {series_id: serie.id}, body: {value: 1}.to_json

      current_count = Sample.all.length
      json_response = JSON.parse(response.body)
      assert json_response["id"]
      assert prev_count == 0 && current_count == 1
    end
  end

  context "peaks" do
    let(:serie) { Serie.create! }
    
    it "computes peaks" do
      # Example from PDF description
      values = [1,1.1,0.9,1,1,1.2,2.5,2.3,2.4,1.1,0.8,1.2,1]
      values.each { |v| Sample.create!({serie_id: serie.id, value: v}) }

      get :peaks, params: {series_id: serie.id, threshold: 1.0}

      json_response = JSON.parse(response.body)
      assert json_response == [0,0,0,0,0,0,1,1,1,0,0,0,0]
    end

    it "compute peaks within the specified window" do
      values =  [6, 6, 6, 5, 0, 1, 1, 1, 6]
      values.each { |v| Sample.create!({serie_id: serie.id, value: v}) }

      get :peaks, params: {series_id: serie.id, threshold: 1.0, window: 5}

      json_response = JSON.parse(response.body)
      assert json_response == [0,0,0,0,1]
    end
  end
end
