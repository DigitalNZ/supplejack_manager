# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

class ParsersController < ApplicationController
  load_and_authorize_resource

  respond_to :json, :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: @parsers, serializer: ActiveModel::ArraySerializer }
    end
  end

  def show
    respond_with @parser
  end

  def new
    @source = @parser.source = Source.new
    @source.partner = Partner.new

    if can? :manage, Partner
      @partners = Partner.asc(:name)
    else
      @partners = Partner.where(:id.in => current_user.manage_partners).asc(:name)
    end
  end

  def edit
    @harvest_job = HarvestJob.from_parser(@parser, current_user)
    @enrichment_job = EnrichmentJob.from_parser(@parser, current_user)
  end

  def create
    @parser.user_id = current_user.id
    @source = @parser.source

    if @parser.save
      redirect_to edit_parser_path(@parser)
    else
      render :new
    end
  end

  def update
    @parser.attributes = params[:parser]
    @parser.user_id = current_user.id
    @parser.update_contents_parser_class!

    if @parser.save
      redirect_to edit_parser_path(@parser)
    else
      render :edit
    end
  end

  def destroy
    @parser.destroy unless @parser.running_jobs?
    redirect_to parsers_path
  end

  def allow_flush
    @parser.allow_full_and_flush = (params[:allow] == 'true')

    if @parser.save
      if params[:allow] == 'false'
        HarvestSchedule.update_schedulers_from_environment({parser_id: @parser.id}, "staging") 
        HarvestSchedule.update_schedulers_from_environment({parser_id: @parser.id}, "production")
      end
      respond_to do |format|
        format.html { redirect_to edit_parser_path(@parser) }
        format.js
      end
    else
      redirect_to edit_parser_path(@parser)  
    end
  end
end
