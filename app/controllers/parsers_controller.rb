# The majority of the Supplejack code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components licensed under the GPL or MIT licenses or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

class ParsersController < ApplicationController

  respond_to :json

  def index
    @parsers = Parser.all
  end

  def show
    @parser = Parser.find(params[:id])
    respond_with @parser
  end

  def new
    @parser = Parser.new
    @source = @parser.source = Source.new
    @source.partner = Partner.new
  end

  def edit
    @parser = Parser.find(params[:id])
    @harvest_job = HarvestJob.from_parser(@parser, current_user)
    @enrichment_job = EnrichmentJob.from_parser(@parser, current_user)
  end

  def create
    @parser = Parser.new(params[:parser])
    @parser.user_id = current_user.id
    @source = @parser.source

    if @parser.save
      redirect_to edit_parser_path(@parser)
    else
      render :new
    end
  end

  def update
    @parser = Parser.find(params[:id])
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
    @parser = Parser.find(params[:id])
    @parser.destroy unless @parser.running_jobs?
    redirect_to parsers_path
  end
end
