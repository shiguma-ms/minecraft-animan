#! /bin/bash

# modディレクトリが存在しなければ作成
if [ ! -d "/data/mods" ]; then
    mkdir -p /data/mods
fi

cd /data/mods

wget https://media.forgecdn.net/files/3475/174/diggusmaximus-1.5.0-1.17.jar
wget https://media.forgecdn.net/files/3454/922/fabric-api-0.40.1%2B1.17.jar
wget https://media.forgecdn.net/files/3438/799/lithium-fabric-mc1.17.1-0.7.4.jar

chown -R minecraft.minecraft /data

exit 0