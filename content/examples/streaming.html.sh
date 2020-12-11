#!/bin/sh

echo "<!doctype html>
<meta charset='utf-8'>
<title>Colorful</title>
<style>
  html { display: flex; min-height: 100%; }
  body { margin: auto; font-family: monospace; font-size: 3em; }
</style>
<body>"

# Please don't actually do this—it's just a silly demo.
for hue in $(seq 0 360)
do
  color="hsl(${hue}deg, 50%, 50%)"
  echo "<style>html { background-color: $color; } body:after { content: \"$color\"; }</style>"
  sleep 0.05
done
