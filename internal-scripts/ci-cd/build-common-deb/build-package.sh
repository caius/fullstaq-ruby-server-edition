#!/bin/bash
set -e

SELFDIR=$(dirname "$0")
ROOTDIR=$(cd "$SELFDIR/../../.." && pwd)
# shellcheck source=../../../lib/library.sh
source "$ROOTDIR/lib/library.sh"

require_envvar PACKAGE_BASENAME
require_envvar VERSION
require_envvar REVISION


UTILITY_IMAGE_NAME=fullstaq/ruby-build-env-utility
UTILITY_IMAGE_TAG=$(read_single_value_file "$ROOTDIR/environments/utility/image_tag")

mkdir output
touch output/"$PACKAGE_BASENAME"

exec docker run --rm --init \
  -v "$ROOTDIR:/system:ro" \
  -v "$(pwd)/output/$PACKAGE_BASENAME:/output/common.deb" \
  -e "VERSION=$VERSION" \
  -e "REVISION=$REVISION" \
  --user "$(id -u):$(id -g)" \
  "$UTILITY_IMAGE_NAME:$UTILITY_IMAGE_TAG" \
  /system/container-entrypoints/build-common-deb
