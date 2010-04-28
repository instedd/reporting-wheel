# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_reportingwheel_session',
  :secret      => '2739af6b0f4bb7c2c0364e8a4d229b4ac0884b8dc2c0501a9fd589d60b6c13995473156c3a0251438d4ecb479e2a6060c6ee5eee4b02fddaf9e3151fca17a786'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
