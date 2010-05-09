# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_aries_session',
  :secret      => '6704734fea896f81256e58801da8fad87f8e9ee8fca30b2a5494b580168a38b6bd72a19a25f857b164ec66b066fc8123675b89afb954eaa2f0ef22f6c94ba7bd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
