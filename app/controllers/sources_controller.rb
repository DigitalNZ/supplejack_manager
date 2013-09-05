class SourcesController < ApplicationController
  # GET /sources
  def index
    @sources = Source.all
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
end
