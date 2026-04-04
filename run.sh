#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

# Create required directories for Homarr v1
mkdir -p /share/homarrv1/db
mkdir -p /share/homarrv1/redis
mkdir -p /share/homarrv1/trusted-certificates

# Set environment variables for Homarr v1
export REDIS_IS_EXTERNAL='false'
export NODE_ENV='production'
export DB_MIGRATIONS_DISABLED='false'

# Docker socket proxy config
if bashio::config.true 'docker_proxy_enabled'; then
    echo "Docker socket proxy is enabled. Configuring environment variables..."

    if [[bashio::config.has_value 'docker_hostnames' && ]]; then
        export DOCKER_HOSTNAMES=$(bashio::config 'docker_hostnames')
    fi
    if [[bashio::config.has_value 'docker_ports' && bashio::config.true 'docker_proxy_enabled']]; then
        export DOCKER_PORTS=$(bashio::config 'docker_ports')
    fi
fi

# Database config
export DB_URL=$(bashio::config 'db_url')
export DB_DIALECT=$(bashio::config 'db_dialect')

# Automatically select database driver based on the selected dialect if the driver is not explicitly set
case "$DB_DIALECT" in
    "sqlite")
        export DB_DRIVER='better-sqlite3'
        ;;
    "postgresql")
        export DB_DRIVER='node-postgres'
        ;;
    "mysql")
        export DB_DRIVER='mysql2'
        ;;
    *)
        echo "Unsupported database dialect: $DB_DIALECT"
        exit 1
        ;;
esac

if bashio::config.has_value 'db_host'; then
    export DB_HOST=$(bashio::config 'db_host')
fi
if bashio::config.has_value 'db_port'; then
    export DB_PORT=$(bashio::config 'db_port')
fi
if bashio::config.has_value 'db_name'; then
    export DB_NAME=$(bashio::config 'db_name')
fi
if bashio::config.has_value 'db_user'; then
    export DB_USER=$(bashio::config 'db_user')
fi
if bashio::config.has_value 'db_password'; then
    export DB_PASSWORD=$(bashio::config 'db_password')
fi

echo "Selected database dialect: $DB_DIALECT"

# Authentication config
if bashio::config.true 'auth_credentials_enabled'; then
    export AUTH_PROVIDERS="credentials"
fi

if bashio::config.has_value 'auth_logout_redirect_url'; then
    export AUTH_LOGOUT_REDIRECT_URL=$(bashio::config 'auth_logout_redirect_url')
fi
export AUTH_SESSION_EXPIRY_TIME=$(bashio::config 'auth_session_expiry_time')
export SECRET_ENCRYPTION_KEY=$(bashio::config 'secret_encryption_key')

# OIDC config
if bashio::config.true 'auth_oidc_enabled'; then
    echo "Configuring OIDC authentication provider..."

    if (-v AUTH_PROVIDERS); then
        export AUTH_PROVIDERS="$AUTH_PROVIDERS,oidc"
    else
        export AUTH_PROVIDERS='oidc'
    fi

    if bashio::config.has_value 'auth_oidc_issuer'; then
        export AUTH_OIDC_ISSUER=$(bashio::config 'auth_oidc_issuer')
    fi
    if bashio::config.has_value 'auth_oidc_client_id'; then
        export AUTH_OIDC_CLIENT_ID=$(bashio::config 'auth_oidc_client_id')
    fi
    if bashio::config.has_value 'auth_oidc_client_secret'; then
        export AUTH_OIDC_CLIENT_SECRET=$(bashio::config 'auth_oidc_client_secret')
    fi
    if bashio::config.has_value 'auth_oidc_client_name'; then
        export AUTH_OIDC_CLIENT_NAME=$(bashio::config 'auth_oidc_client_name')
    fi
    if bashio::config.has_value 'auth_oidc_auto_login'; then
        export AUTH_OIDC_AUTO_LOGIN=$(bashio::config 'auth_oidc_auto_login')
    fi
    if bashio::config.has_value 'auth_oidc_scope_overwrite'; then
        export AUTH_OIDC_SCOPE_OVERWRITE=$(bashio::config 'auth_oidc_scope_overwrite')
    fi
    if bashio::config.has_value 'auth_oidc_groups_attribute'; then
        export AUTH_OIDC_GROUPS_ATTRIBUTE=$(bashio::config 'auth_oidc_groups_attribute')
    fi
    if bashio::config.has_value 'auth_oidc_name_attribute_overwrite'; then
        export AUTH_OIDC_NAME_ATTRIBUTE_OVERWRITE=$(bashio::config 'auth_oidc_name_attribute_overwrite')
    fi
    if bashio::config.has_value 'auth_oidc_force_userinfo'; then
        export AUTH_OIDC_FORCE_USERINFO=$(bashio::config 'auth_oidc_force_userinfo')
    fi
    if bashio::config.has_value 'auth_oidc_enable_dangerous_account_linking'; then
        export AUTH_OIDC_ENABLE_DANGEROUS_ACCOUNT_LINKING=$(bashio::config 'auth_oidc_enable_dangerous_account_linking')
    fi
fi

# LDAP config
if bashio::config.true 'auth_ldap_enabled'; then
    echo "Configuring LDAP authentication provider..."

    if (-v AUTH_PROVIDERS); then
        export AUTH_PROVIDERS="$AUTH_PROVIDERS,ldap"
    else
        export AUTH_PROVIDERS='ldap'
    fi

    if bashio::config.has_value 'auth_ldap_uri'; then
        export AUTH_LDAP_URI=$(bashio::config 'auth_ldap_uri')
    fi
    if bashio::config.has_value 'auth_ldap_base'; then
        export AUTH_LDAP_BASE=$(bashio::config 'auth_ldap_base')
    fi
    if bashio::config.has_value 'auth_ldap_bind_dn'; then
        export AUTH_LDAP_BIND_DN=$(bashio::config 'auth_ldap_bind_dn')
    fi
    if bashio::config.has_value 'auth_ldap_bind_password'; then
        export AUTH_LDAP_BIND_PASSWORD=$(bashio::config 'auth_ldap_bind_password')
    fi
    if bashio::config.has_value 'auth_ldap_username_attribute'; then
        export AUTH_LDAP_USERNAME_ATTRIBUTE=$(bashio::config 'auth_ldap_username_attribute')
    fi
    if bashio::config.has_value 'auth_ldap_user_mail_attribute'; then
        export AUTH_LDAP_USER_MAIL_ATTRIBUTE=$(bashio::config 'auth_ldap_user_mail_attribute')
    fi
    if bashio::config.has_value 'auth_ldap_group_class'; then
        export AUTH_LDAP_GROUP_CLASS=$(bashio::config 'auth_ldap_group_class')
    fi
    if bashio::config.has_value 'auth_ldap_group_member_attribute'; then
        export AUTH_LDAP_GROUP_MEMBER_ATTRIBUTE=$(bashio::config 'auth_ldap_group_member_attribute')
    fi
    if bashio::config.has_value 'auth_ldap_group_member_user_attribute'; then
        export AUTH_LDAP_GROUP_MEMBER_USER_ATTRIBUTE=$(bashio::config 'auth_ldap_group_member_user_attribute')
    fi
    if bashio::config.has_value 'auth_ldap_search_scope'; then
        export AUTH_LDAP_SEARCH_SCOPE=$(bashio::config 'auth_ldap_search_scope')
    fi
    if bashio::config.has_value 'auth_ldap_username_filter_extra_arg'; then
        export AUTH_LDAP_USERNAME_FILTER_EXTRA_ARG=$(bashio::config 'auth_ldap_username_filter_extra_arg')
    fi
    if bashio::config.has_value 'auth_ldap_group_filter_extra_arg'; then
        export AUTH_LDAP_GROUP_FILTER_EXTRA_ARG=$(bashio::config 'auth_ldap_group_filter_extra_arg')
    fi
fi

# Exporting hostname for nginx configuration
echo "Exporting hostname..."
export HOSTNAME="${HOSTNAME:-localhost}"

# Run the original Homarr v1 entrypoint and run script
echo "Starting Homarr..."
exec /app/entrypoint.sh sh /app/run.sh