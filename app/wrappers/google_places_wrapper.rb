class GooglePlacesWrapper

  include Normalizable::InstanceMethods

  GOOGLE_API_KEY = ENV['google_places_api_key']

  def initialize(params = {query: 'pizza', lt: 40.704628, lg: -74.014155})
    #stubbed out init for now
    #need to move the static search params from #search here
    @query = params[:query]
    @lat = params[:lt]
    @lon = params[:lg]
  end

  def search


      radius = 1000 #in meters

      #Build API query (Multi-line for readability)
      url = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
      url += "query=#{@query}&"
      url += "location=#{@lat},#{@lon}&"
      url += "radius=#{radius}&"
      url += "key=#{GOOGLE_API_KEY}"

      #SSL currently only works by `curl`ing from the app (not terminal `curl` or http get from app)
      uri = URI.parse(url)
      system "curl '#{uri}' > google_response"
      results = JSON.parse(File.read("google_response"))

      #Format data
      results["results"].map { |result|
        if result["rating"]
          {
            key: format_key_address(result["formatted_address"].gsub(/,[^,]+$/,"")),
            name: result["name"],
            address: result["formatted_address"].gsub(/\s#.,+/,","),
            rating: result["rating"]
          }
        end
      }.compact
    end

end