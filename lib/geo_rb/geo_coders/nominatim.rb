module GeoRb
  module GeoCoders
    class Nominatim < Base
      DEFAULT_NOMINATIM_DOMAIN = "https://nominatim.openstreetmap.org".freeze
      API_PATHS = {
        search: "/search",
        reverse: "/reverse"
      }.freeze
      STRUCTURED_QUERY_PARAMS = %w[street city county state country postalcode].freeze

      # @param [String | Hash] query: query can be a string or a hash for a structured query
      #                               whose keys are one of: `street`, `city`, `county`, `state`,
      #                               `country`, `postalcode`. For more information, see Nominatim's
      #                               documentation for `structured requests`:
      #                               https://nominatim.org/release-docs/develop/api/Search
      # @param [Boolean] detailed: Include a breakdown of the address into elements
      # @param [Boolean] exactly_one: Return one result or a list of results, if available.
      #
      # @param [ nil | Integer] limit: Maximum amount of results to return from Nominatim.
      #                         Unless exactly_one is set to False, limit will always be 1.
      #
      # @param [Array] country_codes: Limit search results to a specific country (or a list of countries).
      #                               A country_code should be the ISO 3166-1alpha2 code,
      #                               e.g. ``gb`` for the United Kingdom, ``de`` for Germany, etc.
      #
      # @param [ nil | Array] viewbox: refer this area to find search results. Requires an array of Pointer.
      #                                By default this is treated as a hint, if you want to restrict results
      #                                to this area, specify ``bounded=True`` as well.
      # @param [Boolean] bounded: Restrict the results to only items contained within the bounding ``viewbox``.
      def geocode(query, detailed: false, language: nil, country_codes: [], viewbox: nil, exactly_one: true, limit: nil, bounded: false)
        params = case query
          when Hash
            query.slice(STRUCTURED_QUERY_PARAMS)
          else
            {'q': query}
        end

        if exactly_one
          params[:limit] = 1
        elsif limit.nil?
          raise "Limit cannot be less than 1" if limit < 1
          params[:limit] = limit
        end

        params[:bounded] = 1 if bounded
        params[:addressdetails] = 1 if detailed
        params[:countrycodes] = country_codes.join(",") unless country_codes.empty?
        params[:format] = "json"
        params[:"accept-language"] = language if language
        params[:viewbox] = format_bounding_box(viewbox[0], viewbox[1]) if viewbox

        url = build_url(:search, params)
        GeoRb.logger.debug url
        proc = ->(data) { data.first } if exactly_one
        call(url, proc)
      end

      private

      def parse_payload(data)
        data.map do |result|
          result[:latitude] = Float(result.delete(:lat))
          result[:longitude] = Float(result.delete(:lon))

          params = {
            address: result[:display_name],
            raw: result,
            point: Point.new(result[:latitude], result[:longitude])
          }.compact

          Location.new(**params)
        end
      end

      def api(path)
        DEFAULT_NOMINATIM_DOMAIN + API_PATHS[path]
      end

      def build_url(path, params)
        params = URI.encode_www_form(params.to_a)
        "#{api(path)}?#{params}"
      end
    end
  end
end
