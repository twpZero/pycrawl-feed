# pycrawl-feed

The JSON output of [pycrawl](https://github.com/twpZero/pycrawl), my small crawler for security news monitoring. Every day a GitHub Actions job runs pycrawl and commits the fresh `pycrawlfeed.json` here, so anyone can fetch the feed with a single URL.

## Browse it

[twpzero.github.io/pycrawl-feed](https://twpzero.github.io/pycrawl-feed/) shows the feed as a compact page (keywords with their articles, word trends, a filter) with a *Raw JSON* tab to view, copy or download the file.

## Fetch it

The JSON stays directly reachable, on GitHub Pages or raw:

```bash
curl -s https://twpzero.github.io/pycrawl-feed/pycrawlfeed.json
curl -s https://raw.githubusercontent.com/twpZero/pycrawl-feed/master/pycrawlfeed.json
```

## Format

```json
{
  "Updated": "2026-10-17T05:17:42Z",
  "Veille": {
    "ransomware": ["https://…", "https://…"],
    "botnets":    []
  },
  "Trends": {
    "5": "word,word,…",
    "6": "word,word,…"
  }
}
```

* **Updated**: when the crawl ran, in UTC.
* **Veille** (French for *monitoring*): the watched keywords, each with the new article links that mention it in that run. Empty when nothing new was found.
* **Trends**: the words seen most often during the crawl, grouped by number of occurrences (5 or more), as comma-separated lists.

## How it updates

* `.github/workflows/update-feed.yml` runs `update-feed.sh` every day at 05:17 UTC (or on demand from the Actions tab).
* `update-feed.sh` clones [pycrawl](https://github.com/twpZero/pycrawl), crawls the sources listed in its `crawl.conf`, and writes `pycrawlfeed.json` and `links.dump` (the links seen on earlier runs, so only new ones land in *Veille*). It keeps the old feed if every source failed.
* `register.dump` lists the watched keywords. Sources and the word blacklist live in pycrawl's `crawl.conf`.

To run it by hand: `./update-feed.sh`, then commit the two files.

## Make your own

Run [pycrawl](https://github.com/twpZero/pycrawl)'s `pycrawlJson.py` with your own sources and keywords, then commit the result to a repository like this one. A static file on GitHub is all the hosting a feed needs.
