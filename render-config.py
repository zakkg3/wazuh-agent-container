#!/usr/bin/env python3
from loguru import logger
from jinja2 import Template
import os

def create_config_file():
    logger.info(f"Create Wazuh agent configuration for node {node_name}")
    with open("ossec.jinja2") as file_:
        template = Template(file_.read(), autoescape=True)
        config = template.render(
            join_manager_hostname=join_manager_worker,
            join_manager_port=join_manager_port,
            virus_total_key=virus_total_key,
        )
    wazuh_config_file = open("/var/ossec/etc/ossec.conf", "w")
    wazuh_config_file.write(f"{config} \n")
    wazuh_config_file.close()
    # open("/var/ossec/etc/local_internal_options.conf", "wb").write(
    #     open("local_internal_options.jinja2", "rb").read()
    # )
    logger.info(
        "Configuration has been generated from template."
    )

if __name__ == "__main__":
    join_manager_port = os.environ.get("WAZUH_MANAGER_PORT", default=1514)
    virus_total_key = os.environ.get("VIRUS_TOTAL_KEY")
    join_manager_worker = os.environ.get("WAZUH_MANAGER")
    if not join_manager_worker:
        os.environ["WAZUH_MANAGER"] = "wazuh-workers.wazuh.svc.cluster.local"
        join_manager_worker = "wazuh-workers.wazuh.svc.cluster.local"

