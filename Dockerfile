FROM debian:buster-slim

LABEL maintainer "zakkg3"
ARG AGENT_VERSION="4.10.0-1"
LABEL description "Wazuh Agent"

COPY entrypoint.sh ossec.jinja2 render-config.py /

RUN apt-get update && apt-get install -y \
  procps curl apt-transport-https gnupg2 inotify-tools python-docker python3-pip && \
  curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add - && \
  echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | tee /etc/apt/sources.list.d/wazuh.list && \
  apt-get update && \
  apt-get install -y wazuh-agent=${AGENT_VERSION} && \
  rm -rf /var/lib/apt/lists/*

RUN pip3 install Jinja2==3.1.4 && \
  chmod +x /render-config.py && \
  apt-get clean autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
  rm -rf  /tmp/* /var/tmp/* /var/log/* && \
  chown -R wazuh:wazuh /var/ossec/

ENTRYPOINT ["/entrypoint.sh"]
