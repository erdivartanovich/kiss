#!/usr/bin/env bash

kitty @ --to=unix:@kiss focus-window &&
    kitty @ --to=unix:@kiss launch --type=os-window --os-window-class=kiss kiss.sh
