#!/usr/bin/env bash
# usage: ./render-mermaid.sh img/foo.mmd   -> img/foo.svg, rendered by kroki.io, fonts patched for the deck
set -euo pipefail
out="${1%.mmd}.svg"
curl -sf -X POST https://kroki.io/mermaid/svg -H 'Content-Type: text/plain' --data-binary @"$1" -o "$out"
# kroki measures label boxes with its own fonts; let text overflow and use the deck font so nothing clips
sed -i '0,/<svg[^>]*>/s||&<style>foreignObject{overflow:visible} .nodeLabel,.edgeLabel,.label,text{font-family:Inter,Helvetica,Arial,sans-serif !important} .edgeLabel{color:#a1a1aa}</style>|' "$out"
echo "wrote $out"
