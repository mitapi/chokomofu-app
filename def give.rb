  def give
    snack_key = params[:snack_type].to_s
    unless Interaction.snack_types.key?(snack_key)
      return render plain: "invalid snack", status: :unprocessable_entity
    end

    user = current_user
    character = Character.first! # 後で選択中キャラに差し替え

    today_count = Interaction
      .where(user: user, character_id: character.id, kind: :snack)
      .where(happened_at: Time.zone.today.all_day)
      .count

    if today_count >= 3
      lines = ["今日のおやつはおしまいだよ"]
      return render turbo_stream: turbo_stream.replace(
        "snack_result",
        partial: "snacks/result",
        locals: { character: character, snack_type: snack_key, lines: lines, limited: true }
      )
    end


                  <%= link_to howto_path(from: "welcome"),
                aria:  { label: "遊び方説明（howto)ページに遷移" },
                class: "group
                        font-bold flex h-10 items-center justify-center z-30
                        rounded-md inline-block bg-amber-400 px-4 py-2 text-white hover:bg-orange-400" do %>
                <span class="block group-active:[transform:translate3d(0,1px,0)]">
                  遊び方ガイドを見てみる！
                </span>
              <% end %>


# test\controllers\top_controller_test.rbにかいてたやつ

require "test_helper"

class TopControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get top_index_url
    assert_response :success
  end
end