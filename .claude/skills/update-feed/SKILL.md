---
name: update-feed
description: Run pycrawl and push a fresh pycrawlfeed.json to pycrawl-feed master. Use when asked to update, refresh or regenerate the pycrawl feed, or to check that the daily update still works.
---

# Update the pycrawl feed

The feed normally updates itself every day at 05:17 UTC (`.github/workflows/update-feed.yml`). Use this skill to update it on demand, or to debug a run.

## Files

| File | Role |
|---|---|
| `update-feed.sh` | Clones twpZero/pycrawl (or takes a local path), crawls, writes the two files below. |
| `pycrawlfeed.json` | The feed: `Updated` (UTC timestamp), `Veille`, `Trends`. `index.html` reads it at load time. |
| `links.dump` | Every link seen on previous runs. Without it, every link looks new. |
| `register.dump` | The watched keywords (JSON list). Edit it to watch or drop a keyword. |

Sources and the word blacklist live in **pycrawl's `crawl.conf`**, not here. Change them in twpZero/pycrawl.

## Steps

1. Commit identity (every commit, no exception):
   ```bash
   git config user.name "TWP_Zero"
   git config user.email "49241247+twpZero@users.noreply.github.com"
   ```
2. Sync with master: `git checkout master && git pull origin master`.
3. Run the crawl from the repo root:
   ```bash
   ./update-feed.sh                      # clones pycrawl
   ./update-feed.sh ../pycrawl           # or uses a local checkout
   ```
   In a cloud session behind the agent proxy, prefix it with `SSL_CERT_FILE=/root/.ccr/ca-bundle.crt` or every HTTPS source fails.
4. Check the output:
   - `[-]` lines are sources that failed. A few are normal (403s, timeouts). Most of them failing means a network problem: stop.
   - The script refuses to write a feed with no trends.
   - Look at the top of `Trends` (`python3 -c "import json;t=json.load(open('pycrawlfeed.json'))['Trends'];[print(k,t[k][:150]) for k in sorted(t,key=int,reverse=True)[:15]]"`). Navigation words, bylines, site names or dates at the top are pollution: add them to `wordblacklist` in pycrawl's `crawl.conf` (never a watched keyword from `register.dump`), push pycrawl, and rerun.
5. Commit and push, straight to master:
   ```bash
   git add pycrawlfeed.json links.dump
   git commit -m "Update the feed for $(date -u +%F)"
   git push origin master
   ```
   One summary sentence, no body, no trailers.
6. GitHub Pages redeploys in about a minute: https://twpzero.github.io/pycrawl-feed/
