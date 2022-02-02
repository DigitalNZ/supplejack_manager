# frozen_string_literal: true

class PreviewChannel < ApplicationCable::Channel
  def subscribed
    preview = Preview.find(params[:id])
    if current_user.id.to_s == preview.user_id
      stream_from "preview_#{preview.id}"
    end
  end

  def unsubscribed
    Preview.find(params[:id]).destroy
  end
end
