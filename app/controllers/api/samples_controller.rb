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
    window = params[:window].to_i
    serie_id = params[:series_id]
    threshold = params[:threshold].to_f

    if (window > 0)
      samples = Sample.by_serie_and_window(serie_id, window).reverse
    else
      samples = Sample.by_serie(serie_id).all
    end

    render json: PeakAnalyzerService.compute_peaks((samples.map &:value), threshold)
  end
end
