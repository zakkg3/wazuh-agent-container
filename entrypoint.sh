#!/bin/bash

# render the config
/render-config.py

# Start the agent
/var/ossec/bin/wazuh-control start
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start agent: $status"
  exit $status
fi

echo "background jobs running, listening for changes"

cleanup()
{
  echo "Closing wazuh agent"
  var/ossec/bin/wazuh-control stop
  exit 0
}

trap cleanup EXIT

while sleep 60; do
  /var/ossec/bin/wazuh-control status > /dev/null 2>&1
  status=$?
  if [ $status -ne 0 ]; then
    echo "looks like the agent died."
    exit 1
  fi
done

