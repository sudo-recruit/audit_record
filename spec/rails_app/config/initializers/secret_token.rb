Rails.application.config.secret_token = '3345678'
Rails.application.config.session_store :cookie_store, :key => "_my_app"
Rails.application.config.secret_key_base = 'secret value'