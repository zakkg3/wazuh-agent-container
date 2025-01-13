# wazuh-agent-container

Current version 4.10.0

Wazuh agent on a container. Wazuh Docker agent. 

So here we render the config form the enviroment variables and then let the agent do the magic.
We mount the root fs on /rootfs and on the config we specify the directories to whach inside this mounted rootfs folder.

# run like this:

[podman|docker] pull quay.io/flag5/wazuh-agent

You can use podman or docker. they are compatible:

    podman run -d --name wazuh -v /:/rootfs:ro --net host --hostname ${HOSTNAME} \
        -e WAZUH_AGENT_NAME=my-agent-hostname \
        -e WAZUH_MANAGER=10.10.10.10 \
        -e WAZUH_REGISTRATION_PASSWORD='test123' \
        -e WAZUH_MANAGER_PORT=55000 \
        -e WAZUH_AGENT_GROUP='agroupname' \
        -e VIRUS_TOTAL_KEY=youtkeyhere \
        -v /etc/os-release:/etc/os-release \
        -v /var/ossec/local_internal_options.conf:/var/ossec/etc/local_internal_options.conf \
        -v /var/ossec/client.keys:/var/ossec/etc/client.keys quay.io/flag5/wazuh-agent

# Config.

The idea is one have to fork this repo and modify the config as requried.
Initially we mount the root folder of the node into /rootfs and on the config we refer this path whatever is needed.


# Sources


There are 2 ways of enrolling an agent ([docs](https://documentation.wazuh.com/current/user-manual/agent/agent-enrollment/enrollment-methods/index.html)).

The recommended is to let the agent erroll using the config.

This repo uses some code form [pyToshka](https://github.com/pyToshka/docker-wazuh-agent) which uses the enrollment using the API, but it stops working after a while.
It also uses some code from [NoEnv](https://github.com/NoEnv/docker-wazuh-agent) which uses the agent configuration for enrollment, but it does not allow to inject config from enviroment variables, and its also outdated.

Source:  https://github.com/zakkg3/wazuh-agent-container