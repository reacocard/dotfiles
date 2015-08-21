#!/bin/sh

if which xiccd >/dev/null; then
  while true; do
    xiccd || true
  done
fi

