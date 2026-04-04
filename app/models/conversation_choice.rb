class ConversationChoice < ApplicationRecord
  belongs_to :conversation
  belongs_to :next_conversation, class_name: "Conversation"
end
