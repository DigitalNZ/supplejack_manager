# frozen_string_literal: true

# app/channels/preview_channel.rb
class PreviewChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "preview_#{params[:version_id]}"
    stream_from 'preview_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
