FROM centos:centos8

ARG PATH=/root/.cabal/bin:/root/.ghcup/bin:/root/.local/bin:/root/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

RUN /bin/bash -c "sed -i 's#^PATH=.*#PATH=$PATH:$HOME/bin:$HOME/.cabal/bin#' $HOME/.bash_profile"
RUN /bin/bash -c "echo '** Installing packages' ; yum -y --allowerasing install epel-release tmux jq gnupg libtool autoconf iproute bc tcptraceroute sudo glibc-locale-source glibc-langpack-en e2fsprogs net-tools &&\
    yum -y --allowerasing install python3 coreutils pkgconfig libffi-devel gmp-devel openssl-devel ncurses-libs ncurses-compat-libs systemd systemd-devel libsodium-devel zlib-devel make gcc-c++ git wget gnupg libtool autoconf srm iproute bc tcptraceroute diffutils &&\
    yum -y clean all &&\
    rm -rf /var/cache/yum/"

RUN /bin/bash -c ". /root/.bashrc &&\
    mkdir -pv /root/tmp &&\
    cd /root/tmp &&\
    curl -sS -o prereqs.sh https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/prereqs.sh &&\
    chmod 755 prereqs.sh &&\
    sed -i 's/^SUDO=/SUDO='N'/' prereqs.sh &&\
    echo '** Executing prereqs.sh refresh' ; ./prereqs.sh"

