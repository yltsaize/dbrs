FROM container-registry.oracle.com/database/enterprise:19.3.0.0

USER root

RUN yum install -y tcpdump sudo \
    && echo -e "oracle\tALL=(ALL)\tNOPASSWD: ALL" >> /etc/sudoers

USER oracle
