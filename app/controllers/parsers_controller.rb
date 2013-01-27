class ParsersController < ApplicationController

  before_filter :authenticate_user!

  def index
    @parsers = Parser.all
  end

  def new
    @parser = Parser.new
  end

  def edit
    @parser = Parser.find(params[:id])
    @harvest_job = HarvestJob.from_parser(@parser)
  end

  def create
    @parser = Parser.new(params[:parser])
    @parser.user_id = current_user.id

    if @parser.save(current_user)
      redirect_to edit_parser_path(@parser)
    else
      render :new
    end
  end

  def update
    @parser = Parser.find(params[:id])
    @parser.user_id = current_user.id

    if @parser.update_attributes(params[:parser])
      redirect_to edit_parser_path(@parser)
    else
      render :edit
    end
  end

  def destroy
    @parser = Parser.find(params[:id])
    @parser.destroy
    redirect_to parsers_path
  end
end
