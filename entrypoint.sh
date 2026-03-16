#!/bin/bash

set -euo pipefail

set_prop () {
  local key="$1"
  local value="$2"
  local file="server.properties"

  if grep -q "^$key=" "$file"; then
    sed -i "s|^$key=.*|$key=$value|" "$file"
  else
    echo "$key=$value" >> "$file"
  fi
}

if [[ -f "server.properties" ]]; then
  set_prop enable-rcon "${ENABLE_RCON}"
  set_prop rcon.password "${RCON_PASS}"
  set_prop enforce-secure-profile "${SECURE_PROFILE}"
  set_prop gamemode "${GAMEMODE}"
  set_prop hardcore "${HARDCORE}"
  set_prop motd "${MOTD}"
  set_prop pvp "${PVP}"
  set_prop online-mode "${ONLINE_MODE}"
  set_prop difficulty "${DIFFICULTY}"
fi

echo "Iniciando servidor Minecraft..."

exec java -Xms$JAVA_XMS -Xmx$JAVA_XMX $PARAMS -jar /data/server.jar nogui