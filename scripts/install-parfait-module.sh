#!/bin/zsh

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 /absolute/path/to/firefox-profile" >&2
  exit 1
fi

PROFILE_DIR="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CHROME_DIR="$PROFILE_DIR/chrome"
USER_CHROME_FILE="$CHROME_DIR/userChrome.css"
USER_CONTENT_FILE="$CHROME_DIR/userContent.css"
PARFAIT_TARGET="$CHROME_DIR/parfait"

if [[ ! -d "$PROFILE_DIR" ]]; then
  echo "Firefox profile directory does not exist: $PROFILE_DIR" >&2
  exit 1
fi

mkdir -p "$CHROME_DIR"
touch "$USER_CHROME_FILE" "$USER_CONTENT_FILE"

ln -sfn "$PROJECT_DIR/parfait" "$PARFAIT_TARGET"
cp "$PROJECT_DIR/user.js" "$PROFILE_DIR/user.js"

USER_CHROME_IMPORT='@import "parfait/parfait.css";'
USER_CONTENT_IMPORT='@import "parfait/pages.css";'

if ! grep -Fqx "$USER_CHROME_IMPORT" "$USER_CHROME_FILE"; then
  printf '\n%s\n' "$USER_CHROME_IMPORT" >> "$USER_CHROME_FILE"
fi

if ! grep -Fqx "$USER_CONTENT_IMPORT" "$USER_CONTENT_FILE"; then
  printf '\n%s\n' "$USER_CONTENT_IMPORT" >> "$USER_CONTENT_FILE"
fi

cat <<EOF
Installed Parfait as a module into:
  $PROFILE_DIR

Updated:
  $USER_CHROME_FILE
  $USER_CONTENT_FILE

Linked:
  $PARFAIT_TARGET

Copied:
  $PROFILE_DIR/user.js

Next steps:
1. Restart Firefox.
2. Confirm Parfait loads alongside your existing chrome setup.
3. Delete $PROFILE_DIR/user.js after the first successful launch.
4. Adjust import order in your CSS files if your own rules should override Parfait.
EOF
