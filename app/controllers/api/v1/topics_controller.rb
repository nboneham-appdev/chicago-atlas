module Api
  module V1
    class TopicsController < ApiController
      api :GET, '/topics', 'Fetch category, subcategory, indicators list'
      formats ['json']
      description <<-EOS
        == Fetch category, subcategory, indicators
      EOS
      def index
        category_groups = CategoryGroup.with_sub_categories.select { |cg| cg.sub_categories.with_indicators.count > 0 }
        render json: category_groups
      end

      api :GET, '/topic_city/:year/:indicator_id', 'Fetch detailed data of topic'
      param :year, String, :desc => 'year', :required => true
      param :indicator_id, String, :desc => 'indicator id', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for indicatior and year in city area
        response data has detailed data for indicator and year
      EOS
      def city_show
        year  = params[:year]
        slug  = params[:indicator_id]
        city  = GeoGroup.find_by_geography('City')
        @data = Resource.where("year_from <= ? AND year_to >= ?", year, year).where(indicator_id: slug).where(geo_group_id: city.id)
        render json: @data, each_serializer: TopicCitySerializer
      end

      api :GET, '/topic_area/:year/:indicator_id', 'Fetch detailed data of topic'
      param :year, String, :desc => 'year', :required => true
      param :indicator_id, String, :desc => 'indicator id', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for indicatior and year in city area
        response data has detailed data for indicator and year
      EOS
      def area_show
        year  = params[:year]
        slug  = params[:indicator_id]
        city  = GeoGroup.find_by_geography('City')
        @data = Resource.where("year_from <= ? AND year_to >= ?", year, year).where(indicator_id: slug).where.not(geo_group_id: city.id)
        render json: @data, each_serializer: TopicAreaSerializer
      end

      api :GET, '/topic_detail/:indicator_id', 'Fetch detailed data of topic for trend'
      param :indicator_id, String, :desc => 'indicator id', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for indicatior
        response data has detailed data for indicator(for trend all year data)
      EOS
      def trend
        slug  = params[:indicator_id]
        @data = Resource.where(indicator_id: slug)
        render json: @data, each_serializer: TopicDetailSerializer
      end

      api :GET, '/topic_recent/:indicator_id', 'Fetch detailed data of topic'
      param :indicator_id, String, :desc => 'indicator id', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for indicatior and year
        response data has detailed data for indicator and year
      EOS
      def recent
        slug  = params[:indicator_id]
        year  = Resource.maximum('year_to', :conditions => [indicator_id: slug])
        @data = Resource.where("year_from <= ? AND year_to >= ?", year, year).where(indicator_id: slug)
        render json: @data
      end

      api :GET, '/topic_info/:geo_slug/:indicator_id', 'Fetch detailed data of topic for community area'
      param :indicator_id, String, :desc => 'indicator id', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for community area
      EOS
      def info
        indicator_id  = params[:indicator_id]
        geo_slug      = params[:geo_slug]
        geo_group_id  = GeoGroup.find_by_slug(geo_slug)
        chicago_id    = GeoGroup.find_by_slug('chicago')
        @area_data    = Resource.where(indicator_id: indicator_id, geo_group_id: geo_group_id)
        @city_data    = Resource.where(indicator_id: indicator_id, geo_group_id: chicago_id)
        render :json => {
          :area_data => @area_data,
          :city_data => @city_data
        }
      end
    end
  end
end
