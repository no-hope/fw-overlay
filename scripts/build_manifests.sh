#!/bin/bash
OVERLAY_DIR="$(readlink -f $(dirname $0)/..)"
echo "Manifest build process started for overlay directory --> [${OVERLAY_DIR}]"
git --git-dir=${OVERLAY_DIR}/.git clean -X -f
find ${OVERLAY_DIR} -name \*.ebuild -exec ebuild {} manifest \;
