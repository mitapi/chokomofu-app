class AddPoseToMofuDiaries < ActiveRecord::Migration[7.1]
  def change
    add_column :mofu_diaries, :pose, :string
  end
end
