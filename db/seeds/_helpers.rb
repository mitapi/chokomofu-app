def upsert_conversation(code:, attrs:)
  record = Conversation.find_or_initialize_by(code: code)
  record.update!(attrs)
  record
end

def upsert_choice(conversation_id:, position:, label:, next_conversation_id:)
  record = ConversationChoice.find_or_initialize_by(
    conversation_id: conversation.id, position: position
  )
  record.update!(label: label, next_conversation_id: next_conversation.id)
  record
end
