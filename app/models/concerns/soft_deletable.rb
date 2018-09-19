module SoftDeletable
  extend ActiveSupport::Concern

  included do
    field :deleted_at, type: DateTime

    default_scope { where(deleted_at: nil) }
  end

  def delete(options = {})
    self.deleted_at = DateTime.now

    save(options)
  end

  def deleted?
    deleted_at.present?
  end
end