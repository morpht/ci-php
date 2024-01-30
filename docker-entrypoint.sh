#!/bin/sh
# Set memory limit
php -d memory_limit=512M "$@"
