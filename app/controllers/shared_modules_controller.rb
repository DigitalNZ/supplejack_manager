class SharedModulesController < ApplicationController

  respond_to :html, :json

  def index
    @shared_modules = SharedModule.all
  end

  def new
    @shared_module = SharedModule.new
  end

  def edit
    @shared_module = SharedModule.find(params[:id])
  end

  def create
    @shared_module = SharedModule.new(params[:shared_module])
    @shared_module.user_id = current_user.id

    if @shared_module.save
      redirect_to edit_shared_module_path(@shared_module)
    else
      render :new
    end
  end

  def update
    @shared_module = SharedModule.find(params[:id])
    @shared_module.user_id = current_user.id

    if @shared_module.update_attributes(params[:shared_module])
      redirect_to edit_shared_module_path(@shared_module)
    else
      render :edit
    end
  end

  def search
    @shared_module = SharedModule.find_by_name(params[:name])
    respond_with @shared_module
  end
end