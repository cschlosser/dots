#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <source-repo> [output-dir]"
    echo "  source-repo: path to the dots repo (with initialized submodules)"
    echo "  output-dir:  where to create the unified repo (default: ./unified)"
    exit 1
fi

SOURCE="$(cd "$1" && pwd)"
OUTPUT="${2:-./unified}"
case "$OUTPUT" in /*) ;; *) OUTPUT="$(pwd)/$OUTPUT" ;; esac

if [ -d "$OUTPUT" ]; then
    echo "Error: $OUTPUT already exists. Remove it first."
    exit 1
fi

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT
mkdir -p "$WORKDIR/patches"

# Step 1: Clone and rewrite parent repo (remove submodule paths from all history)
echo "==> Preparing parent repo..."
git clone --no-local "$SOURCE" "$WORKDIR/parent"
git -C "$WORKDIR/parent" checkout pub
git -C "$WORKDIR/parent" filter-repo \
    --invert-paths --path nvim --path fish --path .gitmodules --force

# Step 2: Rewrite each submodule's history into its subdirectory
for sub in nvim fish; do
    echo "==> Rewriting $sub into $sub/..."
    git clone --no-local "$SOURCE/$sub" "$WORKDIR/$sub"
    git -C "$WORKDIR/$sub" checkout pub
    git -C "$WORKDIR/$sub" filter-repo --to-subdirectory-filter "$sub" --force
done

# Step 3: Export non-merge commits as patches with full committer metadata.
# Uses committer dates with a monotonic adjustment per-repo so that the
# cross-repo sort respects each repo's topological order.
echo "==> Exporting patches..."
> "$WORKDIR/manifest"
for repo in parent nvim fish; do
    prev_ts=0
    seq=0
    while IFS=$'\t' read -r hash ct cn ce ci; do
        if [ "$ct" -le "$prev_ts" ]; then
            sort_ts=$((prev_ts + 1))
        else
            sort_ts=$ct
        fi
        prev_ts=$sort_ts

        padded_seq=$(printf '%04d' $seq)
        patch_file="$WORKDIR/patches/${repo}_${padded_seq}.patch"
        git -C "$WORKDIR/$repo" format-patch -1 "$hash" --stdout > "$patch_file"
        printf '%s\t%s\t%s\t%s\t%s\n' \
            "$sort_ts" "$ci" "$cn" "$ce" "$patch_file" >> "$WORKDIR/manifest"
        seq=$((seq + 1))
    done < <(git -C "$WORKDIR/$repo" log --reverse --no-merges \
        --format='%H%x09%ct%x09%cn%x09%ce%x09%cI')
done

# Step 4: Create unified repo with object alternates (needed for --3way
# to resolve context mismatches from interleaving commits across repos).
echo "==> Applying patches in chronological order..."
git init -b pub "$OUTPUT"

mkdir -p "$OUTPUT/.git/objects/info"
for repo in parent nvim fish; do
    echo "$WORKDIR/$repo/.git/objects" >> "$OUTPUT/.git/objects/info/alternates"
done

sort -n -k1,1 -t$'\t' -s "$WORKDIR/manifest" | while IFS=$'\t' read -r _ ci cn ce patch_file; do
    [ -s "$patch_file" ] || continue
    if ! GIT_COMMITTER_NAME="$cn" GIT_COMMITTER_EMAIL="$ce" GIT_COMMITTER_DATE="$ci" \
            git -C "$OUTPUT" am --3way "$patch_file" 2>/dev/null; then
        git -C "$OUTPUT" checkout --theirs . 2>/dev/null
        git -C "$OUTPUT" add -A
        GIT_COMMITTER_NAME="$cn" GIT_COMMITTER_EMAIL="$ce" GIT_COMMITTER_DATE="$ci" \
            git -C "$OUTPUT" am --continue 2>/dev/null
    fi
done

# Repack while alternates are still live, then remove them
git -C "$OUTPUT" repack -a -d -q
rm "$OUTPUT/.git/objects/info/alternates"

echo ""
echo "==> Done! Unified repo at: $OUTPUT"
echo "    Branch: pub"
echo "    Verify: git -C $OUTPUT log --oneline"
echo "    File history: git -C $OUTPUT log --follow nvim/init.lua"
