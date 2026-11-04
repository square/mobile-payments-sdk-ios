#!/bin/sh
# Credentials stay outside git but must be bundled for the lab's single-account app.
set -eu

credentials="${SRCROOT}/../Shared/MPoCLabCredentials.plist"
destination="${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/MPoCLabCredentials.plist"

if [ "${ACTION}" = "install" ]; then
    if [ "${SKIP_SETUP_SCRIPT:-NO}" = "YES" ]; then
        echo "error: The SDK setup script must run for a lab archive."
        exit 1
    fi
    if [ ! -f "$credentials" ]; then
        echo "error: Configure the ignored Example/Shared/MPoCLabCredentials.plist before archiving."
        exit 1
    fi
    for key in squareApplicationID accessToken locationID expectedLocationID; do
        if ! value=$(/usr/libexec/PlistBuddy -c "Print :${key}" "$credentials" 2>/dev/null) || [ -z "$value" ]; then
            echo "error: Missing ${key} in the local lab credentials plist."
            exit 1
        fi
    done
    application_id=$(/usr/libexec/PlistBuddy -c 'Print :squareApplicationID' "$credentials")
    case "$application_id" in
        sq0idp-*) ;;
        *) echo "error: The lab archive requires a production Square application ID."; exit 1 ;;
    esac
    location_id=$(/usr/libexec/PlistBuddy -c 'Print :locationID' "$credentials")
    expected_location_id=$(/usr/libexec/PlistBuddy -c 'Print :expectedLocationID' "$credentials")
    if [ "$location_id" != "$expected_location_id" ]; then
        echo "error: The lab archive must use the expected location from the local configuration."
        exit 1
    fi
fi

if [ -f "$credentials" ]; then
    mkdir -p "$(dirname "$destination")"
    cp "$credentials" "$destination"
    chmod 600 "$destination"
else
    rm -f "$destination"
fi
