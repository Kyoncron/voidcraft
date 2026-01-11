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

screen -wipe >/dev/null 2>&1 || true

screen -DmS "$SESSION" sh -lc "exec java -Xms$JAVA_XMS -Xmx$JAVA_XMX $PARAMS -jar /data/server.jar nogui"

# Espera a que screen exista
for i in 1 2 3 4 5; do
  screen -list | grep -q "\.${SESSION}" && break
  sleep 1
done

echo "Minecraft corriendo en screen session: $SESSION"
echo "Para mandar comandos: screen -S $SESSION -p 0 -X stuff 'say hola$(printf \\r)'"

# Mantén el contenedor vivo mientras viva el server
# (si el server se cae, screen se termina y salimos)
while screen -list | grep -q "\.${SESSION}"; do
  sleep 2
done

echo "La sesión screen terminó; saliendo."
exit 1