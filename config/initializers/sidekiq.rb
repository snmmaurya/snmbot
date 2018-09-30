require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  user == Settings.sidekiq.username && password == Settings.sidekiq.password
end