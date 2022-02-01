# frozen_string_literal: true

class PreviewSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :parser_code,
    :parser_id,
    :index,
    :user_id,
    :raw_data,
    :harvested_attributes,
    :api_record,
    :status,
    :deletable,
    :field_errors,
    :validation_errors,
    :harvest_failure,
    :harvest_job_errors,
    :format
  )
end
