class RenamePoseToIllustInMofuDiaries < ActiveRecord::Migration[7.1]
  def change
    rename_column :mofu_diaries, :pose, :illust
  end
end
