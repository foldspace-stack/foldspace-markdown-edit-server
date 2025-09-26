#!/bin/sh
set -e

# 设置基本认证
if [ -n "$BASIC_AUTH_USER" ] && [ -n "$BASIC_AUTH_PASSWORD" ]; then
    echo "Setting up basic authentication for user: $BASIC_AUTH_USER"
    # 创建 htpasswd 文件
    htpasswd -b -c /etc/nginx/auth/.htpasswd "$BASIC_AUTH_USER" "$BASIC_AUTH_PASSWORD" 2>/dev/null || \
    # 如果 htpasswd 不可用，使用 openssl 替代
    { 
        echo "Using openssl as fallback for password generation"
        echo "$BASIC_AUTH_USER:$(openssl passwd -apr1 $BASIC_AUTH_PASSWORD)" > /etc/nginx/auth/.htpasswd
    }
    echo "Basic authentication configured"
else
    echo "WARNING: BASIC_AUTH_USER or BASIC_AUTH_PASSWORD not set, disabling authentication"
    # 禁用 nginx 认证
    sed -i 's/auth_basic/# auth_basic/g' /etc/nginx/conf.d/default.conf
    sed -i 's/auth_basic_user_file/# auth_basic_user_file/g' /etc/nginx/conf.d/default.conf
fi

# 设置 NOTE_STORAGE_PATH 环境变量（如果需要传递给应用）
if [ -n "$NOTE_STORAGE_PATH" ]; then
    export NOTE_STORAGE_PATH
fi