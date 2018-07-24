FROM httpd-24-rhel7
MAINTAINER "Matthew Miller" <matmille@redhat.com>

RUN yum repolist --disablerepo=* \
        && yum-config-manager --disable \* > /dev/null  \
        && yum-config-manager --enable rhel-7-server-rpms \
        && yum-config-manager --enable rhel-7-server-extras-rpms \
        && yum-config-manager --enable rhel-7-server-optional-rpms \
        && yum-config-manager --enable rhel-7-server-ansible-2.5-rpms 

RUN yum -y update; yum clean all
RUN yum -y install ansible; yum clean all
RUN mkdir -p /etc/ansible/roles \
        && printf '[local]\nlocalhost\n' > /etc/ansible/hosts
RUN mkdir -p /files

COPY MapServerorg.yml /
COPY files/example.map /files

RUN ansible-playbook /MapServerorg.yml  
RUN yum clean all

USER root

EXPOSE 8080


