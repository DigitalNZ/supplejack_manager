# The majority of the Supplejack code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components licensed under the GPL or MIT licenses or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

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