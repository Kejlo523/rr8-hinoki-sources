#!/usr/bin/env bash
# Build only the new RR tree, with a fresh Android build environment.
set -eo pipefail

jobs=${1:-16}
source_root=$(realpath -- "${2:-/home/kejlo/xperia_XA1/source/resurrection-remix-Q-hinoki}")
if [[ ! "$jobs" =~ ^[1-9][0-9]*$ ]]; then
    echo "Usage: bash build-rr.sh [JOBS] [SOURCE_ROOT]" >&2
    exit 2
fi
test -f "$source_root/device/sony/hinoki/rr_hinoki.mk"
test -x "$source_root/prebuilts/jdk/jdk9/linux-x86/bin/java"

if [ ! -d "$source_root/out" ]; then
    python3 - "$source_root" <<'PY'
import shutil
import sys
free = shutil.disk_usage(sys.argv[1]).free
if free < 120 * 2**30:
    raise SystemExit(f'First full RR build needs free disk space; only {free / 2**30:.1f} GiB available')
PY
fi

log_dir=/home/kejlo/xperia_XA1/build-logs
mkdir -p "$log_dir"
log_file="$log_dir/rr-Q-hinoki-$(date +%Y%m%d-%H%M%S).log"
printf 'Source: %s\nJobs: %s\nLog: %s\n' "$source_root" "$jobs" "$log_file"

# Do not inherit OUT_DIR, Java, product, SPL or GMS variables from RisingOS.
env -i \
    HOME="$HOME" USER="${USER:-kejlo}" LOGNAME="${LOGNAME:-kejlo}" \
    SHELL=/bin/bash PATH="$PATH" LANG=C.UTF-8 LC_ALL=C.UTF-8 TERM=xterm \
    LD_LIBRARY_PATH="$HOME/.local/legacy-build-libs/lib/x86_64-linux-gnu:$HOME/.local/libsigsegv/usr/lib/x86_64-linux-gnu" \
    M4="$HOME/.local/bin/m4" \
    BUILD_USERNAME=Kejlo BUILD_HOSTNAME=endozero \
    RR_BUILDTYPE=Unofficial RR_BUILD=hinoki days_to_log=1 \
    OUT_DIR=out USE_CCACHE=false \
    bash --noprofile --norc -c '
        set -eo pipefail
        cd "$1"
        export JAVA_HOME="$PWD/prebuilts/jdk/jdk9/linux-x86"
        export ANDROID_JAVA_HOME="$JAVA_HOME"
        export ANDROID_JAVA8_HOME="$PWD/prebuilts/jdk/jdk8/linux-x86"
        export PATH="$JAVA_HOME/bin:$PATH"
        source build/envsetup.sh
        lunch rr_hinoki-userdebug
        m "-j$2" bacon
    ' rr-hinoki-build "$source_root" "$jobs" 2>&1 | tee "$log_file"
