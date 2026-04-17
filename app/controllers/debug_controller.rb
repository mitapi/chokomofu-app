class DebugController < ApplicationController
  def reset_conversations
    head :forbidden and return unless valid_debug_token?

    ActiveRecord::Base.transaction do
      ConversationChoice.delete_all
      Conversation.delete_all
      Rails.application.load_seed
    end

    render plain: "conversations reset done"
  rescue => e
    render plain: "reset failed: #{e.class} #{e.message}", status: :internal_server_error
  end

  private

  def valid_debug_token?
    token = params[:token].to_s
    expected = ENV["DEBUG_DELETE_TOKEN"].to_s
    expected.present? && ActiveSupport::SecurityUtils.secure_compare(token, expected)
  end
end