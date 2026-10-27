#!/bin/bash
# Reproduce the port on the exact manifest baselines; never reset a user's tree.
set -euo pipefail

bundle_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source_root=$(realpath -- "${1:?Usage: apply-patches.sh SOURCE_ROOT}")

while read -r project baseline patch_directory; do
    project_root="$source_root/$project"
    test -d "$project_root" || { echo "Missing project: $project" >&2; exit 1; }
    test -z "$(git -C "$project_root" status --porcelain)" || {
        echo "Uncommitted changes in $project; preserving them" >&2
        exit 1
    }
    current=$(git -C "$project_root" rev-parse HEAD)
    if [ "$current" != "$baseline" ]; then
        echo "$project is not at its pinned base ($baseline)." >&2
        echo "It may already contain the port. Nothing was reset or overwritten." >&2
        exit 1
    fi
    if git -C "$project_root" show-ref --verify --quiet refs/heads/rr-Q-hinoki; then
        echo "Branch rr-Q-hinoki already exists in $project; preserving it" >&2
        exit 1
    fi
done < "$bundle_dir/patch-projects.tsv"

while read -r project baseline patch_directory; do
    project_root="$source_root/$project"
    git -C "$project_root" switch -c rr-Q-hinoki
    for patch in "$bundle_dir/patches/$patch_directory/"*.patch; do
        git -C "$project_root" \
            -c user.name=Kejlo \
            -c user.email=62387434+Kejlo523@users.noreply.github.com \
            am --3way "$patch"
    done
    git -C "$project_root" diff --check
done < "$bundle_dir/patch-projects.tsv"

echo 'Hinoki patches applied. No build was started.'
