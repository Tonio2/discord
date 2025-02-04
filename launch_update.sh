#!/bin/bash
gnome-terminal -- bash -c "$HOME/scripts/discord/update.sh; exit_code=\$?; if [[ \$exit_code -ne 0 ]]; then echo 'An error occurred. Check logs for details.'; read -p 'Press Enter to close...'; fi; exit \$exit_code"
