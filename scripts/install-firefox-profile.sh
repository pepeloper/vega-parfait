#!/bin/zsh

set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 /absolute/path/to/firefox-profile [--force-standalone]" >&2
  exit 1
fi

PROFILE_DIR="$1"
MODE="${2:-}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CHROME_DIR="$PROFILE_DIR/chrome"
USER_CHROME_TARGET="$CHROME_DIR/userChrome.css"
USER_CONTENT_TARGET="$CHROME_DIR/userContent.css"
PARFAIT_TARGET="$CHROME_DIR/parfait"

if [[ ! -d "$PROFILE_DIR" ]]; then
  echo "Firefox profile directory does not exist: $PROFILE_DIR" >&2
  exit 1
fi

mkdir -p "$CHROME_DIR"

if [[ "$MODE" == "--force-standalone" ]]; then
  ln -sfn "$PROJECT_DIR/userChrome.css" "$USER_CHROME_TARGET"
  ln -sfn "$PROJECT_DIR/userContent.css" "$USER_CONTENT_TARGET"
else
  if [[ -e "$USER_CHROME_TARGET" && ! -L "$USER_CHROME_TARGET" ]]; then
    echo "Refusing to replace existing $USER_CHROME_TARGET" >&2
    echo "Use scripts/install-parfait-module.sh for an existing chrome setup," >&2
    echo "or rerun this script with --force-standalone if you want Parfait to take over." >&2
    exit 1
  fi

  if [[ -e "$USER_CONTENT_TARGET" && ! -L "$USER_CONTENT_TARGET" ]]; then
    echo "Refusing to replace existing $USER_CONTENT_TARGET" >&2
    echo "Use scripts/install-parfait-module.sh for an existing chrome setup," >&2
    echo "or rerun this script with --force-standalone if you want Parfait to take over." >&2
    exit 1
  fi

  ln -sfn "$PROJECT_DIR/userChrome.css" "$USER_CHROME_TARGET"
  ln -sfn "$PROJECT_DIR/userContent.css" "$USER_CONTENT_TARGET"
fi

ln -sfn "$PROJECT_DIR/parfait" "$PARFAIT_TARGET"
cp "$PROJECT_DIR/user.js" "$PROFILE_DIR/user.js"

cat <<EOF
Installed Parfait into:
  $PROFILE_DIR

Linked:
  $PARFAIT_TARGET

EOF

if [[ "$MODE" == "--force-standalone" || ! -e "$USER_CHROME_TARGET" || -L "$USER_CHROME_TARGET" ]]; then
  cat <<EOF
  $USER_CHROME_TARGET
  $USER_CONTENT_TARGET

Copied:
  $PROFILE_DIR/user.js

Next steps:
1. Restart Firefox.
2. Confirm the theme loads.
3. Delete $PROFILE_DIR/user.js after the first successful launch.
4. Keep editing $PROJECT_DIR/parfait/custom.css for personal tweaks.
EOF
else
  cat <<EOF

Copied:
  $PROFILE_DIR/user.js

Next steps:
1. Add Parfait imports to your existing chrome CSS files.
2. Restart Firefox.
3. Delete $PROFILE_DIR/user.js after the first successful launch.
4. Keep editing $PROJECT_DIR/parfait/custom.css for personal tweaks.
EOF
fi
