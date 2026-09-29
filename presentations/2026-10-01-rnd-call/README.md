# towards Sv2 spec completeness

Slides for the SRI R&D call on 2026-10-01, built with [Marp](https://marp.app/).

```sh
npx @marp-team/marp-cli slides.md --theme-set theme.css        # slides.html
PORT=8080 HOST=0.0.0.0 npx @marp-team/marp-cli -s -I .       # serve on LAN, open /slides.md
TMPDIR=~/snap/firefox/common/tmp npx @marp-team/marp-cli slides.md --theme-set theme.css --browser firefox --allow-local-files --pdf  # slides.pdf (snap firefox needs a reachable TMPDIR)
```

```sh
./render-mermaid.sh img/paths.mmd   # Mermaid source -> SVG via kroki.io
```
