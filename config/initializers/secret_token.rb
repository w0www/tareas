# This file was generated by 'rake generate_secret_token', and should
# not be made visible to public.
# If you have a load-balancing Redmine cluster, you will need to use the
# same version of this file on each machine. And be sure to restart your
# server when you modify this file.
#
# Your secret key for verifying cookie session data integrity. If you
# change this key, all old sessions will become invalid! Make sure the
# secret is at least 30 characters and all random, no regular words or
# you'll be exposed to dictionary attacks.
RedmineApp::Application.config.secret_key_base = 'e3a75d9a4962ab78ad70a29e827c7257b37f9fafe9a19a240848f8ff317024dda832d7476aa2c702'