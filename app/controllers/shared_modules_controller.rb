class SharedModulesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @shared_modules = SharedModule.all
  end

  def new
    @shared_module = SharedModule.build
  end

  def edit
    @shared_module = SharedModule.find(params[:id])
  end

  def create
    @shared_module = SharedModule.build(params[:shared_module])

    if @shared_module.save(params[:shared_module][:message], current_user)
      redirect_to edit_shared_module_path(@shared_module.id)
    else
      render :new
    end
  end

  def update
    @shared_module = SharedModule.find(params[:id])

    if @shared_module.update_attributes(params[:shared_module], current_user)
      redirect_to edit_shared_module_path(@shared_module.id)
    else
      render :edit
    end
  end
end