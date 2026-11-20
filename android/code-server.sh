#!/bin/bash
# The script checks whether a process named code-server is running.
# If so, it exits without starting another instance.
# Otherwise, it starts code-server in the background and appends its output to ~/code-server.log.

# Example
# -------
# ./code-server.sh          # Start (default)
# ./code-server.sh start    # Start
# ./code-server.sh stop     # Stop

# You can add this to ~/.bashrc so the server is always on when you run your `termux`.

LOG_FILE="$HOME/code-server.log"
ACTION="${1:-start}"

case "$ACTION" in
    start)
        if pgrep -x code-server > /dev/null; then
            echo "code-server is already running. Leaving it untouched."
            exit 0
        fi

        nohup code-server >> "$LOG_FILE" 2>&1 &
        echo "code-server started in background (PID: $!)."
        echo "Logging to: $LOG_FILE"
        ;;

    stop)
        if pgrep -x code-server > /dev/null; then
            pkill -x code-server
            echo "code-server stopped."
        else
            echo "code-server is not running."
        fi
        ;;

    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac
