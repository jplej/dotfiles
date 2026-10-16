#!/usr/bin/env bash
# Writes the logind lid drop-in: suspend on battery, lock on AC. Re-runnable.
set -euo pipefail

# Re-exec under sudo so you can run it plainly
[ "$EUID" -eq 0 ] || exec sudo "$0" "$@"

DROPIN=/etc/systemd/logind.conf.d/lid.conf

mkdir -p "$(dirname "$DROPIN")"
cat > "$DROPIN" <<'EOF'
# Lid: suspend on battery, lock-and-stay-awake on AC (xss-lock answers the lock signal)
[Login]
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=lock
EOF

echo "wrote $DROPIN:"
sed 's/^/  /' "$DROPIN"
echo
echo "Reboot to activate — systemd 255 logind has no reload, and restarting it kills X."
