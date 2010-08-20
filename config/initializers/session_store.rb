# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_lembremeuscontatos_session',
  :secret      => 'de5ad1602d8de43c6eb003a51d21d4bcf3af1e99f668894c703240a5fc1d34c9bf61d4006edb70dff879a73dcbccf3608d1a84ca4fcb08a6daf92163150945dc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
