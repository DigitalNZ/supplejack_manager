# frozen_string_literal: true

class PreviewChannel < ApplicationCable::Channel
  def subscribed
    stream_from "preview_channel_#{params[:preview_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    # delete the channel here?
  end
end
