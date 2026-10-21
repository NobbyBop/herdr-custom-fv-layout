# herdr-custom-fv-layout

A [herdr](https://herdr.dev) plugin that gives every new workspace, including worktree
workspaces, the same layout:

```
┌───────────────┬───────────────┐
│   terminal    │  file viewer  │
├───────────────┴───────────────┤
│           terminal            │
└───────────────────────────────┘
```

It runs on the `workspace.created` event. It only acts on a workspace that has a single
pane, so restored workspaces and ones you arranged by hand are left alone.

## Requirements

- herdr **0.9.5** or newer (the plugin sets `min_herdr_version = "0.7.5"`).
- macOS or Linux, with `bash` and `python3` on your `PATH`.
- The [herdr-file-viewer](https://github.com/smarzban/herdr-file-viewer) plugin, installed with
  the plugin id `herdr-file-viewer`. This plugin opens its `file-viewer` pane entrypoint. Without
  it, the bottom terminal still appears but the top-right pane does not.

## Setup

1. Install the file viewer. It may fetch or build a binary during install; if it asks for a
   toolchain, follow its own README.

   ```sh
   herdr plugin install smarzban/herdr-file-viewer
   ```

2. Install this plugin:

   ```sh
   herdr plugin install NobbyBop/herdr-custom-fv-layout
   ```

   Or clone it and link it for local development:

   ```sh
   git clone https://github.com/NobbyBop/herdr-custom-fv-layout
   herdr plugin link ./herdr-custom-fv-layout
   ```

3. Check that both are enabled, then create a workspace to try it:

   ```sh
   herdr plugin list
   ```

Optional: bind the file viewer to a key (it is not needed for this plugin). In
`~/.config/herdr/config.toml`:

```toml
[[keys.command]]
key = "prefix+f"
type = "plugin_action"
command = "herdr-file-viewer.open-file-viewer"
description = "open file viewer in split"
```

Then run `herdr server reload-config`.

## Manual use

The same script is a plugin action, "Apply default layout". Run it on a workspace that still
has a single pane. It does nothing on a workspace that already has more than one.

## Tuning

Edit `scripts/apply-layout.sh`:

- `--ratio 0.75`: share of the height kept by the top row. Lower it for a taller bottom terminal.
- The viewer opens to the right of the top pane. Change `--direction right` to stack it instead.

## Troubleshooting

```sh
herdr plugin log
```

shows each run of the hook with its exit code and stderr.

## Uninstall

```sh
herdr plugin uninstall herdr-custom-fv-layout
```

(Use `herdr plugin unlink herdr-custom-fv-layout` if you linked it.)

## License

MIT
