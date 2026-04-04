class DebugController < ApplicationController
  def remove_old_early_morning
    token = params[:token].to_s
    expected = ENV["DEBUG_DELETE_TOKEN"].to_s

    return head :forbidden if expected.blank? || token != expected

    target_ids = [13, 14, 15]

    deleted_choice_from_count =
      ConversationChoice.where(conversation_id: target_ids).count

    deleted_choice_to_count =
      ConversationChoice.where(next_conversation_id: target_ids).count

    deleted_conversation_count =
      Conversation.where(id: target_ids).count

    ConversationChoice.where(conversation_id: target_ids).destroy_all
    ConversationChoice.where(next_conversation_id: target_ids).destroy_all
    Conversation.where(id: target_ids).destroy_all

    render plain: <<~TEXT
      ok
      deleted conversation_choices(from): #{deleted_choice_from_count}
      deleted conversation_choices(to): #{deleted_choice_to_count}
      deleted conversations: #{deleted_conversation_count}
    TEXT
  end
end