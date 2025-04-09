# frozen_string_literal: true

module Telegram
  class TelegramRequestValidator
    WEB_APP_DATA_CONSTANT = 'WebAppData'
    class << self
      def authenticate(data)
        Rails.logger.info 'Начало проверки данных от пользователя'

        parsed_data = CGI.parse(data)
        hash = parsed_data['hash'][0]
        user_string = parsed_data['user'][0]
        parsed_data.delete('hash')

        key_value_pairs = format_query_params(parsed_data)

        bot_token_signature = generate_secret_key(BOT_TOKEN)
        calculated_hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('SHA256'), bot_token_signature, key_value_pairs)
        return false unless hash == calculated_hash

        parsed_data(user_string)
      end

      private

      def parsed_data(data)
        json_data = JSON.parse(data)
        Rails.logger.info 'Пользователь прошел проверку, парсим его данные'
        {
          telegram_id: json_data['id'],
          first_name: json_data['first_name'],
          last_name: json_data['last_name'],
          username: json_data['username']
        }
      end

      def format_query_params(params)
        params.map do |key, values|
          values.map { |value| "#{key}=#{value}" }
        end.flatten.sort.join("\n")
      end

      def generate_secret_key(bot_token)
        OpenSSL::HMAC.digest(OpenSSL::Digest.new('SHA256'), 'WebAppData', bot_token)
      end
    end
  end
end
