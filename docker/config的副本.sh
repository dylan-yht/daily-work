#!/bin/bash

echo "进入git仓库"
cd /root/nbl/git-source/cnbl-raptor/.git
mv config config.bak

echo "配置config"
cat >> config << EOF
[core]
    repositoryformatversion = 0
    filemode = true
    bare = false
    logallrefupdates = true
[remote "origin"]
    fetch = +refs/heads/*:refs/remotes/origin/*
    url = ssh://git@git.cameobespoke.com:10022/bl/cnbl-raptor.git
[branch "master"]
    remote = origin
    merge = refs/heads/master
[branch "raptor"]
    remote = origin
    merge = refs/heads/raptor
[branch "release"]
    remote = origin
    merge = refs/heads/release
[branch "hsb"]
    remote = origin
    merge = refs/heads/hsb
EOF


cd /root/nbl/git-source/cnbl-raptor
echo "start pull git"
git checkout $1 &&
git pull origin $1

scp  root@172.16.7.124:/root/.ssh/id_rsa  /root/.ssh/
scp  root@172.16.7.124:/root/.ssh/id_rsa.pub  /root/.ssh/

cd /root/.ssh/
chmod 600 id_rsa