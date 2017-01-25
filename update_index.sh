#!/bin/sh

set -e

helm repo index . --url http://charts.linkyard.ch
git add .
git commit -m "Update index."
git push 
