module Api
  class SeriesController < ApplicationController
    def index
      series = Serie.all
      render json: series
    end

    def create
      @serie = Serie.new()
      if @serie.save
        render json: @serie
      else
        error = {error: "Error when creating serie"}
        render json: error, :status => 500
      end
    end
  end
end
