# frozen_string_literal: true

# app/channels/preview_channel.rb
class PreviewChannel < ApplicationCable::Channel
  def subscribed
    stream_from "preview_channel_#{params[:parser_id]}_#{params[:user_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
