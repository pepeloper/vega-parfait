# Local Firefox setup

This workspace now contains the upstream Parfait theme plus a local override layer in `parfait/custom.css`.

## 1. Find your Firefox profile

1. Open Firefox.
2. Go to `about:support`.
3. Find `Profile Folder`.
4. Click `Open Folder`.

On macOS the path is usually under:

`~/Library/Application Support/Firefox/Profiles/<profile>`

## 2. Install this repo into the profile

If your profile already has a `chrome/` folder or an existing `userChrome.css`, use module mode:

```sh
./scripts/install-parfait-module.sh "/absolute/path/to/your/profile"
```

This will:

- preserve your existing `userChrome.css` and `userContent.css`
- append Parfait `@import` lines if missing
- symlink only the `parfait/` folder into the Firefox profile
- copy `user.js` into the profile root for the first restart

If you want Parfait to fully own `userChrome.css` and `userContent.css`, use standalone mode:

Run:

```sh
./scripts/install-firefox-profile.sh "/absolute/path/to/your/profile"
```

Or, if you intentionally want to replace existing chrome entry files:

```sh
./scripts/install-firefox-profile.sh "/absolute/path/to/your/profile" --force-standalone
```

Standalone mode will:

- create the profile's `chrome` directory if needed
- symlink `userChrome.css` and `userContent.css`
- symlink the whole `parfait/` folder so edits here update Firefox immediately
- copy `user.js` into the profile root so Firefox enables the required prefs on next launch

## 3. Restart Firefox once

After Firefox starts with the theme enabled, delete the copied `user.js` file from your Firefox profile root. Parfait's own docs recommend removing it after the first launch so your manual `about:config` changes are not reset on every start.

## 4. Edit the theme here

The safest file to customize is:

- `parfait/custom.css`

This file is already imported by `parfait/parfait.css` and survives upstream theme updates.

Preferences live in:

- `user.js`

Current project defaults:

- custom accent background enabled
- compact URL bar results enabled
- mac-style roundness preset enabled
- lower-noise URL bar suggestions

## ESR note

Your screenshot shows Firefox ESR `140.10.0esr` on macOS. That is still modern Firefox UI, so Parfait should generally be viable. The real risk is not ESR itself, but whether a given theme selector matches your exact build. If anything looks off, we should patch `parfait/custom.css` first before touching upstream component files.

## 5. Useful Firefox preferences

Required for custom CSS:

- `toolkit.legacyUserProfileCustomizations.stylesheets`
- `svg.context-properties.content.enabled`

Already included in `user.js`.

Recommended Parfait docs pages:

- Install: <https://github.com/reizumii/parfait/wiki/Installing-Parfait>
- Configuration: <https://github.com/reizumii/parfait/wiki/Configuration>
- Custom configuration: <https://github.com/reizumii/parfait/wiki/Custom-configuration>
- Post-installation: <https://github.com/reizumii/parfait/wiki/Post-installation>
