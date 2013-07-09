class CollectionRulesController < ApplicationController

  respond_to :json, :html

  def index
    @collection_rules = params[:collection_rules].present? ? CollectionRules.where(params[:collection_rules]) : CollectionRules.all
    respond_with @collection_rules
  end

  def show
    @collection_rule = CollectionRules.find(params[:id])
    respond_with @collection_rule
  end

  def new
    @collection_rule = CollectionRules.new
  end

  def edit
    @collection_rule = CollectionRules.find(params[:id])
  end

  def destroy
    @collection_rule = CollectionRules.find(params[:id])
    @collection_rule.destroy
    redirect_to collection_rules_path
  end

  def create
    @collection_rule = CollectionRules.new(params[:collection_rules])
    if @collection_rule.save
      redirect_to collection_rules_path
    else
      render :new
    end
  end

  def update
    @collection_rule = CollectionRules.find(params[:id])
    if @collection_rule.update_attributes(params[:collection_rules])
      redirect_to collection_rules_path
    else
      render :edit
    end
  end
end