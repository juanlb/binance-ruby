module Binance
  module Api
    module Margin
      class << self
        def query_max_borrow!(asset: nil)
          timestamp = Configuration.timestamp
          params = {asset: asset, timestamp: timestamp}
          path = "/sapi/v1/margin/maxBorrowable"
          Request.send!(api_key_type: :trading, method: :get, path: path,
            params: params, security_type: :trade, tld: Configuration.tld)
        end

        def loan!(asset: nil, amount: nil)
          timestamp = Configuration.timestamp
          params = {asset: asset, amount: amount, timestamp: timestamp}
          path = "/sapi/v1/margin/loan"
          Request.send!(api_key_type: :trading, method: :margin_post, path: path,
            params: params, security_type: :trade, tld: Configuration.tld)
        end

        def repay!(asset: nil, amount: nil)
          timestamp = Configuration.timestamp
          params = {asset: asset, amount: amount, timestamp: timestamp}
          path = "/sapi/v1/margin/repay"
          Request.send!(api_key_type: :trading, method: :margin_post, path: path,
            params: params, security_type: :trade, tld: Configuration.tld)
        end

        def query_loan!(asset: nil, txId: nil)
          timestamp = Configuration.timestamp
          params = {asset: asset, txId: txId,timestamp: timestamp}
          path = "/sapi/v1/margin/loan"
          Request.send!(api_key_type: :trading, method: :get, path: path,
            params: params, security_type: :trade, tld: Configuration.tld)
        end

        def query_repay!(asset: nil, txId: nil)
          timestamp = Configuration.timestamp
          params = {asset: asset, txId: txId,timestamp: timestamp}
          path = "/sapi/v1/margin/repay"
          Request.send!(api_key_type: :trading, method: :get, path: path,
            params: params, security_type: :trade, tld: Configuration.tld)
        end

        def account_details!
          timestamp = Configuration.timestamp
          params = {timestamp: timestamp}
          path = "/sapi/v1/margin/account"
          Request.send!(api_key_type: :trading, method: :get, path: path,
            params: params, security_type: :trade, tld: Configuration.tld)
        end
      end
    end
  end
end