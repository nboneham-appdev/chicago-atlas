class TopicDetailSerializer < ActiveModel::Serializer
  cache key: 'TopicDetail', expires_in: 3.hours
  # attributes :id, :category_group_name, :sub_category_name, :indicator,
  #   :year_from, :year_to, :demo_group, :number, :cum_number, :ave_annual_number,
  #   :crude_rate, :lower_95ci_crude_rate, :upper_95ci_crude_rate, :percent,
  #   :lower_95ci_percent, :upper_95ci_percent, :weight_number,
  #   :weight_percent, :lower_95ci_weight_percent, :upper_95ci_weight_percent
  attributes :id, :year_from, :year_to, :demography, :for_map, :year

  def demography
    object.demo_group.demography if object.demo_group.present?
  end

  def for_map
    if object.geo_group.geography && object.geo_group.geography == 'Community Area'
      true
    else
      false
    end
  end

  def year
    if object.year_from && object.year_to
      object.year_from == object.year_to ? object.year_from : [object.year_from.to_s, object.year_to.to_s].join('-')
    else
      object.year_from
    end
  end

  # def category_group_name
  #   object.category_group.name
  # end

  # def sub_category_name
  #   object.sub_category.name
  # end
end
