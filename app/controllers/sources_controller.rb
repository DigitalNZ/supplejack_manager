# frozen_string_literal: true

class SourcesController < ApplicationController
  load_and_authorize_resource except: :show
  skip_before_action :verify_authenticity_token

  respond_to :html, :json

  def index
    @sources = Source.all
    respond_with @sources
  end

  def show
    @source = Source.custom_find(params[:id])
    authorize! :read, @source

    status = @source.nil? ? :not_found : :ok

    respond_with @source, status: status
  end

  def new
    @source.partner = Partner.new

    if can? :manage, Partner
      @partners = Partner.asc(:name)
    else
      @partners = Partner.find(current_user.manage_partners)
    end
  end

  def edit
    if can? :manage, Partner
      @partners = Partner.asc(:name)
    else
      @partners = Partner.find(current_user.manage_partners)
    end
  end

  def create
    if @source.save
      redirect_to sources_path, notice: 'Source was successfully created.'
    else
      @partners = Partner.asc(:name)
      render :new
    end
  end

  def update
    if @source.update_attributes(source_params)
      redirect_to sources_path, notice: 'Source was successfully updated.'
    else
      render :edit
    end
  end

  def reindex
    Api::Source.reindex(env, @source.id, { date: params[:date] })
  end

  def source_params
    params.require(:source).permit(:source_id, :partner_id, partner_attributes: :name)
  end
end
