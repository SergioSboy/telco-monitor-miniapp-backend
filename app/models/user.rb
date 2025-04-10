# frozen_string_literal: true

class User < ApplicationRecord
  has_many :connection_tests, dependent: :destroy
  has_many :complaints, dependent: :destroy

  def banned?
    state == 'banned'
  end
end
