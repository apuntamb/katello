module Katello
  module Resources
    module Candlepin
      class UpstreamConsumer < UpstreamCandlepinResource
        extend ConsumerResource

        class << self
          def path(id = upstream_consumer_id)
            super(id)
          end

          def remove_entitlement(entitlement_id)
            fail ArgumentError, "No entitlement ID given to remove." if entitlement_id.blank?

            self["entitlements/#{entitlement_id}"].delete
          end

          def export(url, client_cert, client_key, ca_file)
            logger.debug "Sending GET request to upstream Candlepin: #{url}"
            return resource(url, client_cert, client_key, ca_file).get
          rescue RestClient::Exception => e
            raise e
          end

          def update(url, client_cert, client_key, ca_file, attributes)
            logger.debug "Sending POST request to upstream Candlepin: #{url} #{attributes.to_json}"

            return resource(url, client_cert, client_key, ca_file).put(attributes.to_json,
                                                                       'accept' => 'application/json',
                                                                       'accept-language' => I18n.locale,
                                                                       'content-type' => 'application/json')
          end

          def bind_entitlement(**pool)
            JSON.parse(self['entitlements'].post(nil, params: pool))
          end
        end
      end
    end
  end
end
