#!/bin/bash
set -eux
set -o pipefail

fly -t ci sp -p helm-charts -c pipeline.yml
