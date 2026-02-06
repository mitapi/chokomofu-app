module MofuDiariesHelper
  def diary_pose_image_path(diary)
    pose = diary.pose.presence || "idle"

    # 画像仮で入れています
    case pose
    when "snack"
      "diary/pomemaru_snack.png"
    when "talk"
      "diary/pomemaru_kirakira.png"
    else
      "diary/pomemaru_idle.png"
    end
  end
end