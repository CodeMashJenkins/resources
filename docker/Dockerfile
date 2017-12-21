FROM jenkins/jenkins

USER root

# Copy initialization script that creates default user
ENV JENKINS_USER="admin" JENKINS_PASS="admin"
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/default-user.groovy

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

USER jenkins
