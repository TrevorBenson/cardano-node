FROM centos:centos8

ARG NODE_VERSION=%version%

ENV \
    ENV=/etc/profile \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    CNODE_HOME=/opt/cardano/cnode \
    LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH" \
    PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

COPY --from=localhost/chaincrucial/cardano-node:stage2_${NODE_VERSION} /opt/cardano /opt/cardano
COPY --from=localhost/chaincrucial/cardano-node:stage2_${NODE_VERSION} /root/.bashrc /root/
COPY --from=localhost/chaincrucial/cardano-node:stage2_${NODE_VERSION} /root/tmp /root/tmp
COPY --from=localhost/chaincrucial/cardano-node:stage2_${NODE_VERSION} /root/.cabal/bin/* /root/.cabal/bin/
COPY --from=localhost/chaincrucial/cardano-node:stage2_${NODE_VERSION} /usr/local/bin /usr/local/bin
COPY --from=localhost/chaincrucial/cardano-node:stage2_${NODE_VERSION} /usr/local/lib /usr/local/lib

# HYDRA CFG
ADD https://hydra.iohk.io/build/3670619/download/1/mainnet-topology.json /opt/cardano/cnode/files/
ADD https://hydra.iohk.io/build/3670619/download/1/mainnet-shelley-genesis.json /opt/cardano/cnode/files/
ADD https://hydra.iohk.io/build/3670619/download/1/mainnet-byron-genesis.json /opt/cardano/cnode/files/
ADD https://raw.githubusercontent.com/cardano-community/guild-operators/alpha/files/config-mainnet.json /opt/cardano/cnode/files/mainnet-config.json

# HYDRA TESTNET CFG
ADD https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/testnet-byron-genesis.json /opt/cardano/cnode/files/
ADD https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/testnet-shelley-genesis.json /opt/cardano/cnode/files/
ADD https://raw.githubusercontent.com/cardano-community/guild-operators/alpha/files/config-combinator.json /opt/cardano/cnode/files/testnet-config.json

# ENTRY SCRIPT
ADD https://raw.githubusercontent.com/TrevorBenson/cardano-node/entrypoint-leverage-cnode.sh/entrypoint.sh /opt/cardano/cnode/scripts/docker-entrypoint.sh

RUN /bin/bash -c "dnf -y install epel-release&& yum -y clean all && rm -rf /var/cache/yum/"
RUN /bin/bash -c "dnf -y install python3 pkgconfig libffi-devel gmp-devel openssl-devel ncurses-libs ncurses-compat-libs libsodium-devel zlib-devel jq tmux gnupg libtool iproute bc tcptraceroute net-tools e2fsprogs wget glibc-locale-source glibc-langpack-en sqlite libsqlite3x-devel ncurses vim && yum -y clean all && rm -rf /var/cache/yum/"
RUN ln -s /root/.cabal/bin/cardano-node /usr/local/bin/
RUN ln -s /root/.cabal/bin/cardano-cli /usr/local/bin/

ENTRYPOINT ["/opt/cardano/cnode/scripts/docker-entrypoint.sh"]
RUN ["chmod", "+x", "/opt/cardano/cnode/scripts/docker-entrypoint.sh"]
