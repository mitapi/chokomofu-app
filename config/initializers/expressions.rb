# initializerは、config/expressions.ymlを毎回読み込まず、一回読み込んで使えるようにする。
# ユーザーのcookie持続にかかわらず、サーバー（コンテナ）が動いている限りは有効。デプロイやrenderスリープではリセットされる。

EXPRESSIONS = Rails.application.config_for(:expressions).deep_symbolize_keys