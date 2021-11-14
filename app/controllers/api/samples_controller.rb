class Api::SamplesController < ApplicationController
  def index
    samples = Sample.by_serie(params[:series_id]).all
    render json: samples
  end

  def create
    body = JSON.parse(request.body.string)

    @sample = Sample.new({serie_id: params[:series_id], value: body["value"]})
    if @sample.save
      render json: @sample
    else
      error = {error: "Error when creating sample: #{@sample.errors.full_messages}"}
      render json: error, :status => :bad_request
    end
  end

  def peaks
    samples = Sample.by_serie(params[:series_id]).all
    threshold = params[:threshold].to_f

    render json: PeakAnalyzerService.compute_peaks((samples.map &:value), threshold)
  end
end
