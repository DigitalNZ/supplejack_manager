class RecordsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :find_parser

  def index
    @previewer = Previewer.new(@parser, params[:parser][:data])
    render layout: false
  end

  def harvest
    @harvester = Harvester.new(@parser, params[:limit])
    @harvester.start
    render layout: false
  end

  def find_parser
    @parser = Parser.find(params[:parser_id])
  end
end