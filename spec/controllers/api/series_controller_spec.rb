require 'rails_helper'

RSpec.describe Api::SeriesController, type: :controller do
  context "index" do
    it "fetches series when there isn't any" do
      get :index

      json_response = JSON.parse(response.body)
      assert json_response == []
    end

    it "fetches series" do
      Serie.create!

      get :index

      json_response = JSON.parse(response.body)
      assert json_response.length == 1
    end
  end

  context "create" do
    it "creates new serie" do
      prev_count = Serie.all.length

      post :create

      current_count = Serie.all.length
      json_response = JSON.parse(response.body)
      assert json_response["id"]
      assert prev_count == 0 && current_count == 1
    end
  end
end
