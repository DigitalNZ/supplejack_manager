# frozen_string_literal: true

class ParsersController < ApplicationController
  load_and_authorize_resource

  respond_to :json, :html

  def index
    @parsers = Parser.all.to_a

    respond_to do |format|
      format.html
      format.json do
        render json: @parsers, serializer: ActiveModel::ArraySerializer
      end
    end
  end

  def show
    respond_with @parser
  end

  def new
    @source = @parser.source = Source.new
    @source.partner = Partner.new

    @partners = if can? :manage, Partner
                  Partner.asc(:name)
                else
                  Partner.where(:id.in => current_user.manage_partners).asc(:name)
                end
  end

  def edit
    @harvest_job = HarvestJob.from_parser(@parser, current_user)
    @enrichment_job = EnrichmentJob.from_parser(@parser, current_user)
  end

  def create
    @parser.user_id = current_user.id
    @source = @parser.source

    @partners = if can? :manage, Partner
                  Partner.asc(:name)
                else
                  Partner.where(:id.in => current_user.manage_partners).asc(:name)
                end

    if @parser.save
      redirect_to edit_parser_path(@parser)
    else
      render :new
    end
  end

  def update
    if @parser.update(parser_params.merge('user_id' => current_user.id))
      @parser.update_contents_parser_class!

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
        HarvestSchedule.update_schedulers_from_environment({parser_id: @parser.id}, 'staging')
        HarvestSchedule.update_schedulers_from_environment({parser_id: @parser.id}, 'production')
      end
      respond_to do |format|
        format.html { redirect_to edit_parser_path(@parser) }
        format.js
      end
    else
      redirect_to edit_parser_path(@parser)
    end
  end

  def parser_params
    params
      .require(:parser)
      .permit(:name, :partner, :source_id, :strategy, :parser_template_name, :message, :content)
  end
end
