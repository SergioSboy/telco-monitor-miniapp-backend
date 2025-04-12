# frozen_string_literal: true

module Api
  class RecommendationsController < ApplicationController
    def index
      recommendations = if params[:problem_type]
                          Recommendation.where(problem_type: params[:problem_type])
                        else
                          Recommendation.all
                        end

      render json: recommendations
    end

    def contextual
      data = params.permit(:ping, :download_speed, :upload_speed).to_h.symbolize_keys

      result = []

      result << { text: 'У вас высокая задержка. Это может быть связано с перегрузкой сети.' } if data[:ping].to_f > 100

      if data[:download_speed].to_f < 5
        result << { text: 'Низкая скорость загрузки. Попробуйте сменить диапазон или сеть.' }
      end

      render json: result
    end
  end
end
