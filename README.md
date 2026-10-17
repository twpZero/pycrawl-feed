# pycrawl-feed

The JSON output of [pycrawl](https://github.com/twpZero/pycrawl), my small crawler for security news monitoring. A script ran pycrawl and committed the fresh `pycrawlfeed.json` here, so anyone could fetch the feed with a single URL.

> **Status:** the last automatic update was in September 2022. The file is kept as a sample of pycrawl's output, not as a live feed.

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

* **Veille** (French for *monitoring*): the watched keywords, each with the new article links that mention it in that run. Empty when nothing new was found.
* **Trends**: the words seen most often during the crawl, grouped by number of occurrences (5 or more), as comma-separated lists.

## Make your own

Run [pycrawl](https://github.com/twpZero/pycrawl)'s `pycrawlJson.py` with your own sources and keywords, then commit the result to a repository like this one. A static file on GitHub is all the hosting a feed needs.
