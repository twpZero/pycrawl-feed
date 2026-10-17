#!/bin/sh
# Crawl the sources with pycrawl and refresh pycrawlfeed.json and links.dump here.
# Usage: ./update-feed.sh [path/to/pycrawl]   (clones twpZero/pycrawl when omitted)
set -eu

FEED=$(cd "$(dirname "$0")" && pwd)
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

PYCRAWL=${1:-}
if [ -z "$PYCRAWL" ]; then
    git clone -q --depth 1 https://github.com/twpZero/pycrawl.git "$WORK/pycrawl"
    PYCRAWL="$WORK/pycrawl"
fi
PYCRAWL=$(cd "$PYCRAWL" && pwd)

# pycrawl reads crawl.conf, register.dump (watched keywords) and links.dump
# (links seen on previous runs) from the current directory.
mkdir "$WORK/run"
cp "$PYCRAWL/crawl.conf" "$FEED/register.dump" "$WORK/run/"
[ -f "$FEED/links.dump" ] && cp "$FEED/links.dump" "$WORK/run/"

cd "$WORK/run"
python3 "$PYCRAWL/pycrawlJson.py"

# A run where every source failed gives no trends: keep yesterday's feed.
python3 - <<'PY'
import json, sys
feed = json.load(open("pycrawlfeed.json"))
if not feed.get("Trends"):
    sys.exit("No trends: every source failed? Feed left unchanged.")
PY

cp pycrawlfeed.json links.dump "$FEED/"
echo "Feed updated: $(python3 -c 'import json; print(json.load(open("pycrawlfeed.json"))["Updated"])')"
