#!/bin/sh
echo '<!doctype html><meta charset="utf-8">'
for n in $(seq 0 100)
do
  sleep 0.03
  printf '█'
done
