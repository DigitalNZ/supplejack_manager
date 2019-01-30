
class Preview < ActiveResource::Base
  include EnvironmentHelpers

  self.site = ENV['PREVIEW_WORKER_HOST'] || ENV['WORKER_HOST']
  headers['Authorization'] = "Token token=#{ENV['PREVIEW_WORKER_HOST'] || ENV['WORKER_HOST']}"

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
    _id
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

  def harvested_attributes_output
    CodeRay.scan(harvested_attributes_json, :json).html(:line_numbers => :table).html_safe
  end

  def validation_errors_output
    JSON.parse(self.validation_errors) unless self.validation_errors.nil?
  end

  def validation_errors?
    JSON.parse(self.validation_errors).any? unless self.validation_errors.nil?
  end

  def deletable?
    self.deletable
  end

  def errors?
    harvest_failure? or validation_errors? or field_errors? or harvest_job_errors.present?
  end
end
