# frozen_string_literal: true

# app/models/concerns/orderable.rb
module Orderable
  extend ActiveSupport::Concern

  included do
    scope :latest, -> { order(updated_at: 'desc') }
  end

end