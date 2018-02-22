
# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
HarvesterManager::Application.config.secret_key_base = ENV['SECRET_TOKEN'] || 'dae5a2dae24885a2d61248da5a61dae242e24885a2d885a4885a2d61d24885a2d61dad6185a2d61'
