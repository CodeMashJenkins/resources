FROM jenkins/jenkins

ARG GOSU_VERSION=1.10

USER root

# Copy initialization scripts
ENV JENKINS_USER="admin" JENKINS_PASS="admin"
COPY *.groovy /usr/share/jenkins/ref/init.groovy.d/

# Copy configurations
COPY config/* /usr/share/jenkins/ref/

# Load plugins from update center
COPY install/plugins-*.txt /usr/share/jenkins/install/
RUN install-plugins.sh < /usr/share/jenkins/install/plugins-standard.txt
RUN install-plugins.sh < /usr/share/jenkins/install/plugins-pipeline.txt
RUN install-plugins.sh < /usr/share/jenkins/install/plugins-blueocean.txt

# Mark installation as fully configured so Jenkins will skip setup wizard
RUN echo ${JENKINS_VERSION} > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
RUN echo ${JENKINS_VERSION} > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion

# **** Enable support for a docker-based agent ****

# Install Docker distribution to get Docker CLI
RUN apt-get update && apt-get install -y apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common \
    && curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo $ID)/gpg | apt-key add - \
	&& add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo $ID) $(lsb_release -cs) stable" \
    && apt-get update && apt-get install -y docker-ce

# Use workaround for Docker socket permissions (based on https://github.com/sudo-bmitch/jenkins-docker)
RUN  dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
 && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
 && chmod +x /usr/local/bin/gosu \
 && gosu nobody true
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]