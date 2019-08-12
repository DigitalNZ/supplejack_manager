# frozen_string_literal: true

module Presenters
  class DatatableParsers
    def initialize(parsers, can_update)
      @parsers = parsers
      @can_update = can_update
    end

    def call
      @parsers.map do |parser|
        {
          id: parser.id,
          name: parser.name,
          strategy: parser.strategy,
          updated_at: parser&.updated_at&.localtime&.to_formatted_s(:long),
          last_editor: parser.last_editor,
          data_type: parser.data_type,
          source: {
            id: parser.source_id,
            name: parser&.source_name
          },
          partner: {
            id: parser.source.partner.id,
            name: parser.partner_name,
          },
          can_update: @can_update
        }
      end
    end
  end
end
