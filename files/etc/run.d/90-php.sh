#!/bin/bash
# PHP Server Control Script for Docker
# Usage: run.php start|stop|restart|status

PID_FILE="/home/user/php-server.pid"
LOG_FILE="/dev/stdout"
PORT="${PHP_PORT:-81}"
HOST="${PHP_HOST:-0.0.0.0}"
DOCROOT="${PHP_DOCROOT:-/var/www/html}"

start_server() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            echo "PHP server is already running (PID: $PID)"
            return 1
        fi
    fi
    
    echo "Starting PHP server on $HOST:$PORT from $DOCROOT..."
    
    # Start PHP server in background
    php84 -S "$HOST:$PORT" -t "$DOCROOT" >> "$LOG_FILE" 2>&1 &
    
    # Store PID
    echo $! > "$PID_FILE"
    
    echo "PHP server started successfully (PID: $(cat "$PID_FILE"))"
    echo "Logs: $LOG_FILE"
}

stop_server() {
    if [ ! -f "$PID_FILE" ]; then
        echo "No PID file found. Server may not be running."
        return 1
    fi
    
    PID=$(cat "$PID_FILE")
    
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Stopping PHP server (PID: $PID)..."
        kill "$PID"
        rm -f "$PID_FILE"
        echo "PHP server stopped"
    else
        echo "Process $PID not found. Cleaning up PID file."
        rm -f "$PID_FILE"
    fi
}

status_server() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            echo "PHP server is running (PID: $PID)"
            echo "Listening on $HOST:$PORT"
            return 0
        else
            echo "PHP server is not running (stale PID file)"
            return 1
        fi
    else
        echo "PHP server is not running"
        return 1
    fi
}

restart_server() {
    stop_server
    sleep 2
    start_server
}

case "$1" in
    start)
        start_server
        ;;
    stop)
        stop_server
        ;;
    restart)
        restart_server
        ;;
    status)
        status_server
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        echo ""
        echo "Environment variables:"
        echo "  PHP_PORT    - Port to listen on (default: 8000)"
        echo "  PHP_HOST    - Host to bind to (default: 0.0.0.0)"
        echo "  PHP_DOCROOT - Document root directory (default: /var/www/html)"
        exit 1
        ;;
esac