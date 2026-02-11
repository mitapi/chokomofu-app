module MofuDiariesHelper
  def diary_pose_image_path(diary)
    pose = diary.pose.presence || "nomal"

    # 画像仮で入れています
    case pose
    when "snack"
      "diary/pomemaru_snack03.png"
    when "talk"
      "diary/pomemaru_talk03.png"
    else
      "diary/pomemaru_nomal.png"
    end
  end
end