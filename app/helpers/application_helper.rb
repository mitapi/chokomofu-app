module ApplicationHelper
  def region_label(region)
    I18n.t("regions.#{region}", default: region)
  end
end
