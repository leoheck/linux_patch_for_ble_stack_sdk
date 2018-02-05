# Patch for BLE SDK Tools
Enable run TI BLE SDK on linux without modifying Code Composer Studio projects.

# Apply patch
    ./fix.sh

# Revert changes
    ./fix.sh -r

# Outputs
It creates some logs on /tmp for debug purpouses

    Expanded command line is on file /tmp/${script_name}.cmd
    Command output is on file /tmp/${script_name}.log

    Scripts: lib_search, frontier, oad_image_tool

