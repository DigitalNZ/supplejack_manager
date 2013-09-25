class LinkCheckRulesController < ApplicationController

  respond_to :json, :html

  before_filter :set_worker_environment

  def index
    @link_check_rules = params[:link_check_rule].present? ? LinkCheckRule.where(params[:link_check_rule]) : LinkCheckRule.all
    respond_with @link_check_rules
  end

  def show
    @link_check_rule = LinkCheckRule.find(params[:id])
    respond_with @link_check_rule
  end

  def new
    @link_check_rule = LinkCheckRule.new
  end

  def edit
    @link_check_rule = LinkCheckRule.find(params[:id])
  end

  def destroy
    @link_check_rule = LinkCheckRule.find(params[:id])
    @link_check_rule.destroy
    redirect_to environment_link_check_rules_path(environment: params[:environment])
  end

  def create
    @link_check_rule = LinkCheckRule.new(params[:link_check_rule])
    if @link_check_rule.save
      redirect_to environment_link_check_rules_path(environment: params[:environment])
    else
      render :new
    end
  end

  def update
    @link_check_rule = LinkCheckRule.find(params[:id])
    if @link_check_rule.update_attributes(params[:link_check_rule])
      redirect_to environment_link_check_rules_path(environment: params[:environment])
    else
      render :edit
    end
  end

  def set_worker_environment
    set_worker_environment_for(LinkCheckRule)
  end
end