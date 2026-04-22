


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