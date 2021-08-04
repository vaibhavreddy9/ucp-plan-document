FROM docker.repo1.uhc.com/jboss-eap-6/eap64-openshift

ARG CONFIG_FOLDER
USER root
LABEL "DT_TAG"="APM WebApp"

RUN mkdir -p /ebiz/app_logs \
	&& chmod -R 777 /ebiz \
	&& mkdir -p /portal/conf/deployucp-plan-documents \
	&& mkdir -p /portal/conf/ucp-plan-documents \
	&& mkdir -p /portal/logs \
	&& chmod -R 777 /portal


COPY build/ucp-plan-documentsConfig-*.zip /portal/conf/deployucp-plan-documents/ucp-plan-documentsConfig.zip
ADD ose-deploy-archive.tar.gz /portal/conf/ucp-plan-documents/

RUN unzip /portal/conf/deployucp-plan-documents/ucp-plan-documentsConfig.zip -d /portal/conf/deployucp-plan-documents \
	&& sed -i.bak "s|</extensions>|&\n<system-properties><property name=\"OPENSHIFT_CONFIG_DIR\" value=\"/portal/conf/deployucp-plan-documents/openshift/applicationContext.xml\"/></system-properties>|g" $JBOSS_HOME/standalone/configuration/standalone-openshift.xml

COPY target/ucp-plan-documents-*.war $JBOSS_HOME/standalone/deployments/ucp-plan-documents.war

# Dynatrace stuff 

COPY entrypoint.sh /portal/conf/entrypoint.sh
RUN chmod +x /portal/conf/entrypoint.sh
COPY install_dynatrace_agents.sh /portal/conf/install_dynatrace_agents.sh
RUN chmod +x /portal/conf/install_dynatrace_agents.sh

RUN /portal/conf/install_dynatrace_agents.sh

### Done with dynatrace stuff

# Splunk stuff

RUN mkdir -p /opt/splunk  
RUN chmod -R 777 /opt/splunk
WORKDIR /opt/splunk  
# Download and unzip Splunk Universal Forwarder  
RUN curl -o splunkforwarder.tgz https://repo1.uhc.com/artifactory/generic-local/monitoring/splunk/latest/splunkforwarder.tgz   
RUN tar xvzf splunkforwarder.tgz  
RUN ls -lrRt

# stage env
RUN curl -o optum_npe_ose_outputs.tgz   https://repo1.uhc.com/artifactory/generic-local/monitoring/splunk/latest/optum_npe_ose_outputs.tgz   


# prod env
RUN curl -o optum_phi_ose_outputs.tgz   https://repo1.uhc.com/artifactory/generic-local/monitoring/splunk/latest/optum_phi_ose_outputs.tgz   

RUN chmod -R 777 /opt/splunk

### Done with splunk stuff
ENTRYPOINT [ "/portal/conf/entrypoint.sh" ]

