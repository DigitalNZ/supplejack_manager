require "snippet"

class Previewer

  attr_reader :parser, :index, :review, :user_id
  attr_accessor :environment

  def initialize(parser, code, user_id, index=0, environment="staging", review=false)
    @parser = parser
    @code = code if code.present?
    @index = index.to_i
    @fetch_error_backtrace = nil
    @environment = environment || "staging"
    @review = review || false
    @user_id = user_id
  end

  def preview
    @preview ||= JSON.parse(RestClient.post("#{ENV["WORKER_HOST"]}/previews", {
      preview: {
        parser_code: @code, 
        parser_id: @parser.id,
        index: @index,
        user_id: user_id
        }}))
  end

  def harvest_job
    @harvest_job ||= HarvestJob.find preview['harvest_job_id']
  end

  def harvest_failure
    preview['errors']['harvest_failure']
  end

  def harvest_failure?
    !!harvest_failure
  end

  def record?
    harvest_job.records_count > 0
  end

  def raw_data?
    !!preview['raw_data']
  end

  def harvested_attributes?
    !!preview['harvested_attributes']
  end

  def api_record_output
    CodeRay.scan(api_record_json, :json).html(:line_numbers => :table).html_safe
  end

  def api_record_json
    JSON.pretty_generate(preview['record'])
  end

  def harvested_attributes_output
    CodeRay.scan(harvested_attributes_json, :json).html(:line_numbers => :table).html_safe
  end

  def harvested_attributes_json
    JSON.pretty_generate(preview['harvested_attributes'])
  end

  def field_errors?
    preview['errors']['field_errors'].any?
  end

  def field_errors_output
    CodeRay.scan(field_errors_json, :json).html(:line_numbers => :table).html_safe if field_errors?
  end

  def validation_errors?
    preview['errors']['validation_errors'].any?
  end

  def validation_errors
    preview['errors']['validation_errors']
  end

  def raw_output
    format = parser.xml? ? :xml : :json
    CodeRay.scan(self.send("pretty_#{format}_output"), format).html(line_numbers: :table).html_safe
  end

  def pretty_xml_output
    preview['raw_data']
  end

  def pretty_json_output
    JSON.pretty_generate(JSON.parse(preview["raw_data"]))
  end

  def field_errors_json
    return nil unless field_errors?
    JSON.pretty_generate(preview['errors']['field_errors'])
  end
end