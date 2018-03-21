
# app/controllers/parser_templates_controller.rb
class ParserTemplatesController < ApplicationController
  load_and_authorize_resource

  def index
    @parser_templates = ParserTemplate.all
  end

  def new; end

  def show; end

  def edit; end

  def destroy
    @parser_template.destroy
    redirect_to parser_templates_path
  end

  def create
    @parser_template.user_id = current_user.id
    if @parser_template.save
      redirect_to edit_parser_template_path(@parser_template.id)
    else
      render :new
    end
  end

  def update
    @parser_template.user_id = current_user.id
    if @parser_template.update_attributes(parser_template_params)
      redirect_to edit_parser_template_path(@parser_template.id)
    else
      render :edit
    end
  end

  def parser_template_params
    params
      .require(:parser_template)
      .permit(:name, :content)
  end
end
