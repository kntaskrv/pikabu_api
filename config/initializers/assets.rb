if Rails.env.development?
  Rails.application.config.assets.precompile += %w[graphiql/rails/application.css graphiql/rails/application.js]
end
