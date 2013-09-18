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
