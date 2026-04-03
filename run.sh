#!/bin/sh

# Create required directories for Homarr v1
mkdir -p /share/homarrv1/db
mkdir -p /share/homarrv1/redis
mkdir -p /share/homarrv1/trusted-certificates

# Set environment variables for Homarr v1
export REDIS_IS_EXTERNAL='false'
export NODE_ENV='production'
export DB_MIGRATIONS_DISABLED='false'
export SECRET_ENCRYPTION_KEY='dc4a514fc67b4f4e629a99b019759f9f32dc4facb55ff2c1a51862597edfcd6e'

# Docker environment variables for Homarr v1
export DOCKER_HOSTNAMES=$(bashio::config 'docker_hostnames')
export DOCKER_PORTS=$(bashio::config 'docker_ports')

# Database configuration for Homarr v1
export DB_URL=$(bashio::config 'db_url')
export DB_DIALECT=$(bashio::config 'db_dialect')
export DB_DRIVER=$(bashio::config 'db_driver')
export DB_HOST=$(bashio::config 'db_host')
export DB_PORT=$(bashio::config 'db_port')
export DB_NAME=$(bashio::config 'db_name')
export DB_USER=$(bashio::config 'db_user')
export DB_PASSWORD=$(bashio::config 'db_password')

# Authentication configuration for Homarr v1
export AUTH_PROVIDERS=$(bashio::config 'auth_providers')
export AUTH_LOGOUT_REDIRECT_URL=$(bashio::config 'auth_logout_redirect_url')
export AUTH_SESSION_EXPIRY_TIME=$(bashio::config 'auth_session_expiry_time')

export AUTH_OIDC_ISSUER=$(bashio::config 'auth_oidc_issuer')
export AUTH_OIDC_CLIENT_ID=$(bashio::config 'auth_oidc_client_id')
export AUTH_OIDC_CLIENT_SECRET=$(bashio::config 'auth_oidc_client_secret')
export AUTH_OIDC_CLIENT_NAME=$(bashio::config 'auth_oidc_client_name')
export AUTH_OIDC_AUTO_LOGIN=$(bashio::config 'auth_oidc_auto_login')
export AUTH_OIDC_SCOPE_OVERWRITE=$(bashio::config 'auth_oidc_scope_overwrite')
export AUTH_OIDC_GROUPS_ATTRIBUTE=$(bashio::config 'auth_oidc_groups_attribute')
export AUTH_OIDC_NAME_ATTRIBUTE_OVERWRITE=$(bashio::config 'auth_oidc_name_attribute_overwrite')
export AUTH_OIDC_FORCE_USERINFO=$(bashio::config 'auth_oidc_force_userinfo')
export AUTH_OIDC_ENABLE_DANGEROUS_ACCOUNT_LINKING=$(bashio::config 'auth_oidc_enable_dangerous_account_linking')

export AUTH_LDAP_URI=$(bashio::config 'auth_ldap_uri')
export AUTH_LDAP_BASE=$(bashio::config 'auth_ldap_base')
export AUTH_LDAP_BIND_DN=$(bashio::config 'auth_ldap_bind_dn')
export AUTH_LDAP_BIND_PASSWORD=$(bashio::config 'auth_ldap_bind_password')
export AUTH_LDAP_USERNAME_ATTRIBUTE=$(bashio::config 'auth_ldap_username_attribute')
export AUTH_LDAP_USER_MAIL_ATTRIBUTE=$(bashio::config 'auth_ldap_user_mail_attribute')
export AUTH_LDAP_GROUP_CLASS=$(bashio::config 'auth_ldap_group_class')
export AUTH_LDAP_GROUP_MEMBER_ATTRIBUTE=$(bashio::config 'auth_ldap_group_member_attribute')
export AUTH_LDAP_GROUP_MEMBER_USER_ATTRIBUTE=$(bashio::config 'auth_ldap_group_member_user_attribute')
export AUTH_LDAP_SEARCH_SCOPE=$(bashio::config 'auth_ldap_search_scope')
export AUTH_LDAP_USERNAME_FILTER_EXTRA_ARG=$(bashio::config 'auth_ldap_username_filter_extra_arg')
export AUTH_LDAP_GROUP_FILTER_EXTRA_ARG=$(bashio::config 'auth_ldap_group_filter_extra_arg')

# Exporting hostname for nginx configuration
echo "Exporting hostname..."
export HOSTNAME="${HOSTNAME:-localhost}"

# Run the original Homarr v1 entrypoint and run script
echo "Starting Homarr v1..."
exec /app/entrypoint.sh sh /app/run.sh
