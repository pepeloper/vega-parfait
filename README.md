# Vega Parfait

Custom Firefox theme workspace based on [Parfait](https://github.com/reizumii/parfait), with local overrides and install scripts for iterating safely on a real Firefox profile.

The main customization surface in this repo is:

- `parfait/custom.css`

This keeps theme tweaks separate from upstream Parfait files and makes future updates easier.

## Firefox profile setup

### 1. Find your Firefox profile

1. Open Firefox.
2. Go to `about:support`.
3. Find `Profile Folder`.
4. Click `Open Folder`.

On macOS the path is usually under:

`~/Library/Application Support/Firefox/Profiles/<profile>`

### 2. Install this repo into the profile

If your profile already has a `chrome/` folder or an existing `userChrome.css`, use module mode:

```sh
./scripts/install-parfait-module.sh "/absolute/path/to/your/profile"
```

This will:

- preserve your existing `userChrome.css` and `userContent.css`
- append Parfait `@import` lines if missing
- symlink only the `parfait/` folder into the Firefox profile
- copy `user.js` into the profile root for the first restart

If you want this repo to fully own `userChrome.css` and `userContent.css`, use standalone mode:

```sh
./scripts/install-firefox-profile.sh "/absolute/path/to/your/profile"
```

If you intentionally want to replace existing chrome entry files:

```sh
./scripts/install-firefox-profile.sh "/absolute/path/to/your/profile" --force-standalone
```

Standalone mode will:

- create the profile's `chrome` directory if needed
- symlink `userChrome.css` and `userContent.css`
- symlink the whole `parfait/` folder so edits here update Firefox immediately
- copy `user.js` into the profile root so Firefox enables the required prefs on next launch

### 3. Restart Firefox once

After Firefox starts with the theme enabled, delete the copied `user.js` file from your Firefox profile root. This prevents your later `about:config` changes from being reset on each launch.

## Customization workflow

Safest file to customize:

- `parfait/custom.css`

Preference defaults live in:

- `user.js`

Current repo defaults:

- custom accent background enabled
- compact URL bar results enabled
- Parfait logo on new tab
- tuned corner radius and ESR-specific fixes
- lower-noise URL bar suggestions

## ESR note

This repo is being tuned against Firefox ESR on macOS. ESR is generally compatible with Parfait, but some selectors and visual spacing can differ from newer Firefox releases. When that happens, prefer patching `parfait/custom.css` before editing upstream component files.

## Required Firefox preferences

Required for custom CSS:

- `toolkit.legacyUserProfileCustomizations.stylesheets`
- `svg.context-properties.content.enabled`

These are already included in `user.js`.

## Reference docs

- [Parfait install guide](https://github.com/reizumii/parfait/wiki/Installing-Parfait)
- [Parfait configuration](https://github.com/reizumii/parfait/wiki/Configuration)
- [Parfait custom configuration](https://github.com/reizumii/parfait/wiki/Custom-configuration)
- [Parfait post-installation notes](https://github.com/reizumii/parfait/wiki/Post-installation)
