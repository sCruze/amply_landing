Rails.application.config.assets.paths << Rails.root.join("app/assets/builds")

Rails.application.config.dartsass.builds = {
  "application.sass" => "application.css"
}

# Source maps в dev
Rails.application.config.dartsass.source_maps = Rails.env.development?

# Сжатие в production
if Rails.env.production?
  Rails.application.config.dartsass.build_options << " --style=compressed"
end
