# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

class LinkCheckRulesController < ApplicationController

  respond_to :json, :html

  before_filter :set_worker_environment
  load_and_authorize_resource

  def index
    @link_check_rules = params[:link_check_rule].present? ? LinkCheckRule.where(params[:link_check_rule]) : LinkCheckRule.all
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
    if current_user.admin?
      @partners = Partner.all
      binding.pry
    else
      @partners = Partner.where(:id.in => current_user.manage_partners).asc(:name)
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
