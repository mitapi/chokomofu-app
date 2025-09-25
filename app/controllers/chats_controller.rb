class ChatsController < ApplicationController
  def show
    @slot = if Rails.env.development? || Rails.env.test?
              params[:slot].presence || "morning"
            else
              "morning"
            end

    @conv = Conversation.find_by!(code: "conv.greet.morning.default")

    if params[:conversation_id].to_s.match?(/\A\d+\z/)
      @conv = Conversation.find_by(id: params[:conversation_id]) || @conv
    end

    @choices = ConversationChoice.where(conversation_id: @conv.id).order(:position)
  end
end
