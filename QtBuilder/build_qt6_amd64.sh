#!/bin/bash

set -e

apt-get update
apt-get install -y ca-certificates curl gnupg
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=16
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
apt-get update
apt-get purge -y libnode72 nodejs

git clone --verbose --depth 1 --branch v$1 https://code.qt.io/qt/qt5.git
cd qt5
perl init-repository
cd ..

mkdir build

cd build
../qt5/configure -release -nomake examples -nomake tests -no-zstd -webengine-proprietary-codecs -prefix /opt/Qt-amd64-$1
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/Qt-amd64-$1/

cd /opt
tar cvfpJ /root/export/Qt-amd64-$1.tar.xz Qt-amd64-$1
