
# app/controllers/link_check_rules_controller.rb
class LinkCheckRulesController < ApplicationController
  respond_to :json, :html

  before_action :set_worker_environment
  load_and_authorize_resource

  def index
    @link_check_rules = params[:link_check_rule].present? ? LinkCheckRule.where(params[:link_check_rule]) : LinkCheckRule.all.select(&:source)
    respond_with @link_check_rules
  end

  def new
    if can? :manage, Partner
      @partners = Partner.asc(:name)
    else
      @partners = Partner.where(:id.in => current_user.manage_partners).asc(:name)
    end
  end

  def edit
    @partners = if current_user.admin?
      Partner.all.asc(:name)
    else
      Partner.where(:id.in => current_user.manage_partners).asc(:name)
    end
  end

  def destroy
    @link_check_rule.destroy
    redirect_to environment_link_check_rules_path(environment: params[:environment])
  end

  def create
    if @link_check_rule.save
      redirect_to environment_link_check_rules_path(environment: params[:environment])
    else
      render :new
    end
  end

  def update
    if @link_check_rule.update_attributes(link_check_rule_params)
      redirect_to environment_link_check_rules_path(environment: params[:environment])
    else
      render :edit
    end
  end

  def set_worker_environment
    set_worker_environment_for(LinkCheckRule)
  end

  private

  def link_check_rule_params
    params.require(:link_check_rule).permit(:source_id, :xpath, :status_codes,
                                            :active, :throttle, :collection_title)
  end
end
