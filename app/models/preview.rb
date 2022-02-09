# frozen_string_literal: true

class Preview
  include EnvironmentHelpers
  include Mongoid::Document
  include Mongoid::Timestamps

  field :parser_code,          type: String
  field :parser_id,            type: String
  field :index,                type: Integer
  field :user_id,              type: String
  field :raw_data,             type: String
  field :harvested_attributes, type: String
  field :api_record,           type: String
  field :status,               type: String
  field :deletable,            type: Boolean
  field :field_errors,         type: String
  field :validation_errors,    type: String
  field :harvest_failure,      type: String
  field :harvest_job_errors,   type: String
  field :format,               type: String

  def start_preview_worker(job_id)
    preview_url = "#{ENV['PREVIEW_WORKER_HOST'] || ENV['WORKER_HOST']}/previews"

    RestClient.post(preview_url, { preview_id: id, job_id: job_id })
  end

  def stop_preview_worker!
    preview_url = "#{ENV['PREVIEW_WORKER_HOST'] || ENV['WORKER_HOST']}/previews"

    RestClient.delete("#{preview_url}/#{id}")
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
    self.status == 'finished'
  end

  def api_record_json
    JSON.pretty_generate(JSON.parse(self.api_record)) unless self.api_record.nil?
  end

  def harvested_attributes_json
    JSON.pretty_generate(JSON.parse(self.harvested_attributes))
  end


  def field_errors?
    JSON.parse(self.field_errors).any? unless self.field_errors.nil?
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
    self.send("pretty_#{attributes['format']}_output")
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
    harvest_failure? || validation_errors? || field_errors? || harvest_job_errors.present?
  end
end
