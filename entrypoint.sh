#!/bin/sh

set -x
echo "Running entrypoint.sh"
cp -r /portal/conf/deployucp-plan-documents/${env} /portal/conf/plananddocumentsappconfig
cp -r /portal/conf/xfiles/ucp-plan-documents/wsskeystore /portal/conf/xfiles/wsskeystore_ucpplandocuments


echo Your env is: "${env}"	
echo Your run mode is: "${runMode}"

if [ "${runMode}" = "stage" ] ; then

	export DT_HOME=/opt/dynatrace/oneagent_stage
	source /opt/dynatrace/oneagent_stage/dynatrace-agent64.sh

elif [ "${runMode}" = "prod" ] ; then

	export DT_HOME"/opt/dynatrace/oneagent_prod"
	source /opt/dynatrace/oneagent_prod/dynatrace-agent64.sh 
else
	echo "Not starting dynatrace agent" 
fi

# Splunk agent 

LOGNAME=PlanDocuments

cat > /opt/splunk/splunkforwarder/etc/system/local/inputs.conf <<EOF
[monitor:///portal/logs/*.log]  
disabled = false  
index = cba_ucp  
sourcetype = ucp:${LOGNAME}_log
ignoreOlderThan = 7d  

[monitor:///opt/eap/standalone/log/gc.log.*]
disabled = false  
index = cba_ucp  
sourcetype = ucp:opt-eap-standalone_log
ignoreOlderThan = 7d  
EOF

ls -lrRt /opt/splunk/splunkforwarder

if [ "${runMode}" = "stage" ] ; then
	cd /opt/splunk/splunkforwarder/etc/apps
	tar xvzf /opt/splunk/optum_npe_ose_outputs.tgz
	/opt/splunk/splunkforwarder/bin/splunk start --accept-license 

elif [ "${runMode}" = "prod" ] ; then
     cd /opt/splunk/splunkforwarder/etc/apps
      tar xvzf /opt/splunk/optum_phi_ose_outputs.tgz  
	/opt/splunk/splunkforwarder/bin/splunk start --accept-license 
else
	echo "Not starting splunk agent" 
fi

set +x
env
if [ -f "/opt/eap/bin/openshift-launch.sh" ] ; then
	source /opt/eap/bin/openshift-launch.sh
fi
