# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'snippet'

# app/models/previewer.rb
class Previewer
  attr_reader :parser, :index, :review, :user_id, :preview_id
  attr_accessor :environment

  def initialize(parser, code, user_id, index = 0, review = false)
    @parser = parser
    @code = code if code.present?
    @index = index.to_i
    @fetch_error_backtrace = nil
    @review = review || false
    @user_id = user_id
  end

  def create_preview_job
    response = RestClient.post("#{ENV['WORKER_HOST']}/previews", {
      preview: {
        format: format.to_s,
        harvest_job: {
          parser_code: @code,
          parser_id: @parser.id,
          environment: 'preview',
          index: index,
          limit: index + 1,
          user_id: user_id
        }
      }
    })
    @preview_id = JSON.parse(response)['_id']
  end

  def format
    parser.xml? ? :xml : :json
  end
end
