#!/bin/bash

# Run all scripts from run.d directory in sorted order
if [ -d "/etc/run.d" ]; then
	for script in $(ls /etc/run.d/*.sh 2>/dev/null | sort); do
		if [ -f "$script" ]; then
			echo "Running $script"
			bash "$script" start
		fi
	done
fi

# Keep container running
tail -f /dev/null