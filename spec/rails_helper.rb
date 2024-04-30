require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

module APIRequestHelpers
  def api_sign_in(user, credential)
    post(
      "/sign_in",
      headers: {
        "Accept" => "application/json",
        "X-API-KEY" => credential.key
      },
      params: {
        login: {
          email: user.email,
          password: user.password
        }
      }
    )
    JSON.parse(response.body)
  end
end


RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures

  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include APIRequestHelpers, type: :request


  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
