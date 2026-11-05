#!/bin/sh
set -eu

# Remove the previous single-account resource when rebuilding in an existing DerivedData directory.
rm -f "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/MPoCLabCredentials.plist"

if [ "${ACTION}" = "install" ] && [ "${SKIP_SETUP_SCRIPT:-NO}" = "YES" ]; then
    echo "error: The SDK setup script must run for a DonutCounter archive."
    exit 1
fi
