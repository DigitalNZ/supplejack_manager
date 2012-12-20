class ParsersController < ApplicationController

  before_filter :authenticate_user!

  def index
    @parsers = Parser.all
  end

  def new
    @parser = Parser.build
  end

  def edit
    @parser = Parser.find(params[:id])
  end

  def create
    @parser = Parser.build(params[:parser])
    if @parser.save(params[:parser][:message], current_user)
      redirect_to edit_parser_path(@parser)
    else
      render :new
    end
  end

  def update
    @parser = Parser.find(params[:id])

    if @parser.update_attributes(params[:parser], current_user)
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
