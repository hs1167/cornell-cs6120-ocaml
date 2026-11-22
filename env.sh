# À sourcer depuis Bash : source ./env.sh
_cs_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
if [[ -x "$_cs_root/_opam/bin/dune" ]]; then
  export OPAM_SWITCH_PREFIX="$_cs_root/_opam"
  if [[ -d "$_cs_root/.tools/opam-root" ]]; then
    export OPAMROOT="$_cs_root/.tools/opam-root"
  fi
elif [[ -x "$HOME/.opam/cs3110/bin/dune" ]]; then
  export OPAM_SWITCH_PREFIX="$HOME/.opam/cs3110"
fi
export PATH="$_cs_root/.tools/bin:$_cs_root/.tools/venv/bin:$_cs_root/_build/install/default/bin:${OPAM_SWITCH_PREFIX:+$OPAM_SWITCH_PREFIX/bin:}$PATH"
export TMPDIR="$_cs_root/.tools/tmp"
export XDG_CACHE_HOME="$_cs_root/.tools/cache"
export DENO_DIR="$_cs_root/.tools/deno-cache"
export DENO_NO_UPDATE_CHECK=1
mkdir -p -- "$TMPDIR" "$XDG_CACHE_HOME"
unset _cs_root
