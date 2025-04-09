# frozen_string_literal: true

class User < ApplicationRecord
  def banned?
    state == 'banned'
  end
end
