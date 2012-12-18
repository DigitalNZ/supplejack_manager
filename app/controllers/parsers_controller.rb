class ParsersController < ApplicationController

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

    if @parser.save
      redirect_to edit_parser_path(@parser)
    else
      render :edit
    end
  end

  def update
    @parser = Parser.find(params[:id])

    if @parser.update_attributes(params[:parser])
      redirect_to edit_parser_path(@parser)
    else
      render :edit
    end
  end

  def destroy
    @parser = Parser.find(params[:id])
    @parser.destroy
  end
end
