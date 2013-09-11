class SourcesController < ApplicationController

  respond_to :html, :json
  
  # GET /sources
  def index
    @sources = Source.all
    respond_with @sources
  end

  # GET /sources/new
  def new
    @source = Source.new
    @source.partner = Partner.new
  end

  # GET /sources/1/edit
  def edit
    @source = Source.find(params[:id])
  end

  def show
    @source = Source.find(params[:id])
    respond_with @source
  end

  # POST /sources
  def create
    @source = Source.new(params[:source])

    if @source.save
      redirect_to sources_path, notice: 'Source was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /sources/1
  def update
    @source = Source.find(params[:id])

    if @source.update_attributes(params[:source])
      redirect_to sources_path, notice: 'Source was successfully updated.'
    else
      render action: "edit"
    end
  end

  def reindex
    @source = Source.find(params[:id])
    url = Figaro.env(params[:env])['API_HOST']
    RestClient.get("#{url}/partners/#{@source.partner.id}/sources/#{@source.id}/reindex?date=#{params[:date]}")
  end
end
