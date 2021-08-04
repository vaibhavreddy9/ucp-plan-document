#!/bin/bash

# install dynatrace agents for both stage and prod.
#
# NOTE : $DT_HOME must be set in entrypoint.sh before running the dynatrace-agent64.sh 
# 
# install stage agent

DT_PAAS_URL="https://dtsaas-sgw-test.uhc.com/e/5a9318f8-b3b8-4df0-9645-f3b8d2cb0b2e/api"
DT_PAAS_TOKEN="79fv6-mqSH2exgCIis6r7"
DT_ONEAGENT_OPTIONS="flavor=default&include=java"
DT_HOME="/opt/dynatrace/oneagent_stage"

echo "$DT_PAAS_URL/v1/deployment/installer/agent/unix/paas/latest?Api-Token=$DT_PAAS_TOKEN&$DT_ONEAGENT_OPTIONS"
mkdir -p "$DT_HOME"
curl -v -k -o "$DT_HOME/oneagent.zip" "$DT_PAAS_URL/v1/deployment/installer/agent/unix/paas/latest?Api-Token=$DT_PAAS_TOKEN&$DT_ONEAGENT_OPTIONS"
ls -l /opt/dynatrace/oneagent_stage/oneagent.zip
unzip -d "$DT_HOME" "$DT_HOME/oneagent.zip"
rm "$DT_HOME/oneagent.zip"

# install prod agent
DT_HOME="/opt/dynatrace/oneagent_prod"
mkdir -p "$DT_HOME"
DT_PAAS_URL="https://dtsaas.uhc.com/e/fe0808dd-d423-4fe0-a6c0-10c05c98ac6c/api"
DT_PAAS_TOKEN="_8i9LDPGQsiJHjzaBHIWv"
DT_ONEAGENT_OPTIONS="flavor=default&include=java"
DT_HOME="/opt/dynatrace/oneagent_prod"

echo "$DT_PAAS_URL/v1/deployment/installer/agent/unix/paas/latest?Api-Token=$DT_PAAS_TOKEN&$DT_ONEAGENT_OPTIONS"
mkdir -p "$DT_HOME"
curl -v -k -o "$DT_HOME/oneagent.zip" "$DT_PAAS_URL/v1/deployment/installer/agent/unix/paas/latest?Api-Token=$DT_PAAS_TOKEN&$DT_ONEAGENT_OPTIONS" 
if [ $? -eq 0 ]; then
  ls -l /opt/dynatrace/oneagent_prod/oneagent.zip
  unzip -d "$DT_HOME" "$DT_HOME/oneagent.zip"
  rm "$DT_HOME/oneagent.zip"
else
  echo "could not download prod dynatrace"
fi
