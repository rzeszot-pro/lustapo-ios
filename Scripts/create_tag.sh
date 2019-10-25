#!/bin/sh

cd "${SOURCE_ROOT}"

TAG_NAME="release/${MARKETING_VERSION}+${CURRENT_PROJECT_VERSION}"

git tag --force --message "autotag ${TAG_NAME}" "${TAG_NAME}"
