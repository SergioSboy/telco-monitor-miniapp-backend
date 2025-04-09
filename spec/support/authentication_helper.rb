# frozen_string_literal: true

module AuthenticationHelper
  def authenticate(user = nil)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    # rubocop:enable RSpec/AnyInstance
  end
end
