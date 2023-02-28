FROM container-registry.oracle.com/database/enterprise:19.3.0.0

USER root

RUN yum install -y tcpdump sudo \
    && echo -e "oracle\tALL=(ALL)\tNOPASSWD: ALL" >> /etc/sudoers

RUN curl -sLo frp.tar.gz https://github.com/fatedier/frp/releases/download/v0.47.0/frp_0.47.0_linux_amd64.tar.gz \
    && tar -zxf frp.tar.gz \
    && sudo mv frp_0.47.0_linux_amd64/frps frp_0.47.0_linux_amd64/frpc /usr/local/bin/ \
    && rm -rf frp_0.47.0_linux_amd64 frp.tar.gz

COPY frpc.ini /frp/frpc.ini
COPY 50-portfwd.sh /opt/oracle/scripts/startup/

USER oracle
