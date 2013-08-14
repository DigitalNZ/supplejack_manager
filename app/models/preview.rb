class Preview < ActiveResource::Base

  self.site = ENV['WORKER_HOST']
  self.user = ENV['WORKER_API_KEY']

  schema do
    attribute :raw_data,               :string
    attribute :harvested_attributes,   :string
    attribute :api_record,             :string
    attribute :status,                 :string
    attribute :deletable,              :boolean
    attribute :field_errors,           :string
    attribute :validation_errors,      :string
    attribute :harvest_failure,        :string
    attribute :harvest_job_errors,     :string
    attribute :format,                 :string
  end

  def id
    self._id
  end

  def harvest_failure?
    !!harvest_failure
  end

  def raw_data?
    raw_data.present?
  end

  def harvested_attributes?
    self.harvested_attributes.present?
  end

  def finished?
    self.status == "finished"
  end

  def api_record_json
    JSON.pretty_generate(JSON.parse(self.api_record)) unless self.api_record.nil?
  end

  def api_record_output
    CodeRay.scan(api_record_json, :json).html(:line_numbers => :table).html_safe
  end

  def harvested_attributes_json
    JSON.pretty_generate(JSON.parse(self.harvested_attributes))
  end

  def harvested_attributes_output
    CodeRay.scan(harvested_attributes_json, :json).html(:line_numbers => :table).html_safe
  end

  def field_errors?
    JSON.parse(self.field_errors).any? unless self.field_errors.nil?
  end

  def field_errors_output
    CodeRay.scan(field_errors_json, :json).html(:line_numbers => :table).html_safe if field_errors?
  end

  def validation_errors_output
    JSON.parse(self.validation_errors) unless self.validation_errors.nil?
  end

  def harvest_failure_output
    JSON.parse(self.harvest_failure) if self.harvest_failure.present?
  end

  def harvest_job_errors_output
    JSON.parse(self.harvest_job_errors) if self.harvest_job_errors.present?
  end

  def validation_errors?
    JSON.parse(self.validation_errors).any? unless self.validation_errors.nil?
  end

  def deletable?
    self.deletable
  end

  def raw_output
    CodeRay.scan(self.send("pretty_#{self.format}_output"), self.format.to_sym).html(line_numbers: :table).html_safe
  end

  def pretty_xml_output
    self.raw_data
  end

  def pretty_json_output
    JSON.pretty_generate(JSON.parse(self.raw_data))
  end

  def field_errors_json
    JSON.pretty_generate(JSON.parse(self.field_errors)) if field_errors?
  end

  def errors?
    harvest_failure? or validation_errors? or field_errors? or harvest_job_errors.present?
  end
  
end