# frozen_string_literal: true

module Telegram
  class RequestValidator
    def self.authenticate(data)
      parsed_data = CGI.parse(data)
      hash = parsed_data['hash']&.first
      user_string = parsed_data['user']&.first
      return false unless hash && user_string

      parsed_data.delete('hash')
      key_value_pairs = QueryFormatter.call(parsed_data)
      calculated_hash = SignatureCalculator.call(key_value_pairs)

      hash == calculated_hash ? UserParser.call(user_string) : false
    end
  end

  class QueryFormatter
    def self.call(params)
      params.flat_map { |k, v| v.map { |val| "#{k}=#{val}" } }.sort.join("\n")
    end
  end

  class SignatureCalculator
    def self.call(data)
      secret = OpenSSL::HMAC.digest(OpenSSL::Digest.new('SHA256'), 'WebAppData', BOT_TOKEN)
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('SHA256'), secret, data)
    end
  end

  class UserParser
    def self.call(json)
      parsed = JSON.parse(json)
      {
        telegram_id: parsed['id'],
        first_name: parsed['first_name'],
        last_name: parsed['last_name'],
        username: parsed['username']
      }
    end
  end
end
