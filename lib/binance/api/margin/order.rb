module Binance
  module Api
    module Margin
      class Order
        class << self
          def create!(symbol: nil, isIsolated: false, side: nil, type: nil, quantity: nil,
                      quoteOrderQty: nil, price: nil, stopPrice: nil, newClientOrderId: nil,
                      icebergQty: nil, newOrderRespType: nil, sideEffectType: nil, timeInForce: nil,
                      recvWindow: nil)
            timestamp = Configuration.timestamp
            params = {
              symbol: symbol, isIsolated: isIsolated, side: side, type: type,
              quantity: quantity, quoteOrderQty: quoteOrderQty, price: price,
              stopPrice: stopPrice, newClientOrderId: newClientOrderId, icebergQty: icebergQty,
              newOrderRespType: newOrderRespType, sideEffectType: sideEffectType,
              timeInForce: timeInForce, recvWindow: recvWindow, timestamp: timestamp,
            }.delete_if { |_, value| value.nil? }
            ensure_required_create_keys!(params: params)
            path = "/sapi/v1/margin/order"
            Request.send!(api_key_type: :trading, method: :margin_post, path: path,
                          params: params, security_type: :trade, tld: Configuration.tld)
          end

          def cancel!(orderId: nil, originalClientOrderId: nil, newClientOrderId: nil, recvWindow: nil, symbol: nil)
            raise Error.new(message: "symbol is required") if symbol.nil?
            raise Error.new(message: "either orderid or originalclientorderid " \
                            "is required") if orderId.nil? && originalClientOrderId.nil?
            timestamp = Configuration.timestamp
            params = { orderId: orderId, origClientOrderId: originalClientOrderId,
                       newClientOrderId: newClientOrderId, recvWindow: recvWindow,
                       symbol: symbol, timestamp: timestamp }.delete_if { |key, value| value.nil? }
            Request.send!(api_key_type: :trading, method: :margin_delete, path: "/sapi/v1/margin/order",
                          params: params, security_type: :trade, tld: Configuration.tld)
          end

          def status!(orderId: nil, symbol: nil)
            timestamp = Configuration.timestamp
            params = {orderId: orderId, symbol: symbol, timestamp: timestamp}
            path = "/sapi/v1/margin/order"
            Request.send!(api_key_type: :trading, method: :get, path: path,
              params: params, security_type: :trade, tld: Configuration.tld)
          end

          def all_open!(recvWindow: 5000, symbol: nil)
            timestamp = Configuration.timestamp
            params = { recvWindow: recvWindow, symbol: symbol, timestamp: timestamp }
            Request.send!(api_key_type: :read_info, path: "/sapi/v1/margin/openOrders",
                          params: params, security_type: :user_data, tld: Configuration.tld)
          end

          private

          def additional_required_create_keys(type:)
            case type
            when :limit
              [:price, :timeInForce].freeze
            when :stop_loss, :take_profit
              [:stopPrice].freeze
            when :stop_loss_limit, :take_profit_limit
              [:price, :stopPrice, :timeInForce].freeze
            when :limit_maker
              [:price].freeze
            else
              [].freeze
            end
          end

          def ensure_required_create_keys!(params:)
            keys = required_create_keys.dup.concat(additional_required_create_keys(type: params[:type]))
            missing_keys = keys.select { |key| params[key].nil? }
            raise Error.new(message: "required keys are missing: #{missing_keys.join(", ")}") unless missing_keys.empty?
          end

          def required_create_keys
            [:symbol, :side, :type, :timestamp].freeze
          end
        end
      end
    end
  end
end
