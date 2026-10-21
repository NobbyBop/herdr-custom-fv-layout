#!/usr/bin/env bash
# Layout: [ terminal | file viewer ] over [ terminal ]. Only touches a workspace whose
# only tab holds a single pane, so restored or hand-built workspaces are left alone.
set -uo pipefail
herdr="${HERDR_BIN_PATH:-herdr}"

ws="${HERDR_WORKSPACE_ID:-}"
[ -n "$ws" ] || ws="$(printf '%s' "${HERDR_PLUGIN_EVENT_JSON:-{\}}" | python3 -c 'import sys,json
d=json.load(sys.stdin)
w=d.get("workspace") or d
print(w.get("workspace_id") or w.get("id") or d.get("workspace_id") or "")' 2>/dev/null)"
[ -n "$ws" ] || { echo "no workspace id" >&2; exit 1; }

panes="$("$herdr" pane list 2>/dev/null | python3 -c 'import sys,json
ws=sys.argv[1]
r=json.load(sys.stdin)["result"]["panes"]
print(*[p["pane_id"] for p in r if p.get("workspace_id")==ws])' "$ws")"
set -- $panes
[ "$#" -eq 1 ] || exit 0
top="$1"

# Bottom terminal first so it spans the full width, then the viewer beside the top pane.
"$herdr" pane split "$top" --direction down --ratio 0.75 --no-focus >/dev/null || exit 1
"$herdr" plugin pane open --plugin herdr-file-viewer --entrypoint file-viewer \
  --placement split --direction right --target-pane "$top" --focus >/dev/null
"$herdr" pane focus "$top" >/dev/null 2>&1 || true
