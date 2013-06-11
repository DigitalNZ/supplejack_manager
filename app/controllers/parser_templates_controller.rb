class ParserTemplatesController < ApplicationController

	def index
		@parser_templates = ParserTemplate.all
	end

	def new
		@parser_template = ParserTemplate.new
	end

	def edit
		@parser_template = ParserTemplate.find(params[:id])
	end

	def destroy
		@parser_template = ParserTemplate.find(params[:id])
		@parser_template.destroy
		redirect_to parser_templates_path
	end

	def create
		@parser_template = ParserTemplate.new(params[:parser_template])
		@parser_template.user_id = current_user.id
		if @parser_template.save
			redirect_to edit_parser_template_path(@parser_template.id)
		else
			render :new
		end
	end

	def update
		@parser_template = ParserTemplate.find(params[:id])
		@parser_template.user_id = current_user.id
		if @parser_template.update_attributes(params[:parser_template])
			redirect_to edit_parser_template_path(@parser_template.id)
		else
			render :edit
		end
	end
end