#!/bin/bash

"$HOME/scripts/discord/update.sh"
exit_code=$?

if [[ $exit_code -ne 0 ]]; then
    zenity --error --text="Discord update failed.\n\nCheck logs for details at $HOME/scripts/discord/logs.txt"
    exit $exit_code
else
    systemd-run --user --quiet --description="Discord Detached" discord
    exit 0
fi
