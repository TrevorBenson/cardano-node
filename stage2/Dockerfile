ARG NODE_VERSION=%version%
FROM localhost/chaincrucial/cardano-node:stage1_${NODE_VERSION}


ARG PATH=/root/.cabal/bin:/root/.ghcup/bin:/root/.local/bin:/root/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
RUN /bin/bash -c ". /root/.bashrc &&\
    mkdir -pv /root/tmp &&\
    cd /root/tmp &&\
    curl -sS -o prereqs.sh https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/prereqs.sh &&\
    chmod 755 prereqs.sh &&\
    sed -i 's/^SUDO=/SUDO='N'/' prereqs.sh &&\
    echo '** Executing prereqs.sh refresh' ; ./prereqs.sh"

RUN /bin/bash -c ". /root/.bashrc &&\
    if [ -d /root/git ] ; then cd /root/git ; else mkdir /root/git  ; fi ;\
    cd /root/git &&\
    git clone https://github.com/input-output-hk/cardano-node &&\
    echo '** Git clone cardano-node' ; cd cardano-node &&\
    echo '** Git fetch' ; git fetch --tags --all &&\
    git pull &&\
    echo '** Git checkout specific version' ; git checkout ${NODE_VERSION} &&\
    echo '** configure cabal.project.local' ; wget https://raw.githubusercontent.com/cardano-community/guild-operators/master/files/cabal.project.local &&\
    echo '** cabal-build-all.sh' ; /opt/cardano/cnode/scripts/cabal-build-all.sh"
RUN /bin/bash -c ". /root/.bashrc ; /root/.cabal/bin/cardano-cli version ; /root/.cabal/bin/cardano-node version"
