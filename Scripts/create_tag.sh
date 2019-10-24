#!/bin/sh

cd "${SOURCE_ROOT}"

TAG_PREFIX=`echo ${TARGET_NAME} | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g'`
TAG_NAME="release/${TAG_PREFIX}-${CURRENT_PROJECT_VERSION}+${MARKETING_VERSION}"

git tag --force --message "autotag ${TAG_NAME}" "${TAG_NAME}"
