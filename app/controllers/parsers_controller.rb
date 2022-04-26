# frozen_string_literal: true

class ParsersController < ApplicationController
  load_and_authorize_resource

  respond_to :json, :html

  def index
    respond_to do |format|
      format.html
      format.json do
        @parsers = Parser.only(%i[name strategy source data_type created_at updated_at last_editor]).all.to_a
        render json: @parsers, serializer: ActiveModel::ArraySerializer
      end
    end
  end

  def datatable
    parsers = Parser.datatable_query(datatable_params)
    render json: {
      data: Presenters::DatatableParsers.new(parsers, can?(:update, Parser)).call,
      recordsTotal: Parser.count,
      recordsFiltered: parsers.length
    }
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
    @parser.allow_full_and_flush = params[:allow] == 'true'

    if @parser.save
      if params[:allow] == 'false'
        APPLICATION_ENVS.each do |env|
          HarvestSchedule.update_schedulers_from_environment({ parser_id: @parser.id }, env)
        end
      end
    end
    redirect_to edit_parser_path(@parser), status: :see_other
  end

  def versions
    @versionable = @parser
    @versions = @parser.versions

    render partial: 'versions/async_list'
  end

  def edit_meta
    @partners = Partner.all
  end

  private
    def parser_params
      params
        .require(:parser)
        .permit(:name, :partner, :source_id, :strategy, :parser_template_name, :message, :content)
    end

    def datatable_params
      sorted_by_column = params[:order]['0'][:column]
      {
        search:      params[:search][:value],
        search_type: params[:search][:type],
        start:       params[:start].to_i,
        per_page:    params[:length].to_i,
        order_by:    params[:columns][sorted_by_column][:data],
        direction:   params[:order]['0'][:dir],
      }
    end
end
