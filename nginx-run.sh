#!/bin/sh
chmod +x /app/setup-auth.sh
/app/setup-auth.sh
exec nginx -g "daemon off;"