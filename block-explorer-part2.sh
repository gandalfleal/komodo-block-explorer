#!/bin/bash

echo "switching to correct node version"
echo

# nvm setup

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm


# switch node setup with nvm
nvm install v4

echo "---------------"
echo "installing bitcore dependencies"
echo

# install zeromq
sudo apt-get -y install libzmq3-dev

echo "---------------"
echo "installing zcash patched bitcore"
echo 
npm install str4d/bitcore-node-zcash

echo "---------------"
echo "setting up bitcore"
echo

# setup bitcore
./node_modules/bitcore-node-zcash/bin/bitcore-node create zcash-explorer

cd zcash-explorer


echo "---------------"
echo "installing insight UI"
echo

../node_modules/bitcore-node-zcash/bin/bitcore-node install str4d/insight-api-zcash str4d/insight-ui-zcash


echo "---------------"
echo "creating config files"
echo

# point zcash at mainnet
cat << EOF > bitcore-node.json
{
  "network": "mainnet",
  "port": 3001,
  "services": [
    "bitcoind",
    "insight-api-zcash",
    "insight-ui-zcash",
    "web"
  ],
  "servicesConfig": {
    "bitcoind": {
      "spawn": {
        "datadir": "./data",
        "exec": "zcashd"
      }
    }
  }
}

EOF

# create zcash.conf
cat << EOF > data/zcash.conf
rpcallowip=127.0.0.1
rpcuser=komodo
rpcpassword=431F2b48d!01e.
txindex=1
addnode=5.9.102.210
addnode=78.47.196.146
addnode=178.63.69.164
addnode=88.198.65.74
addnode=5.9.122.241
addnode=144.76.94.38
addnode=89.248.166.91
whitelist=127.0.0.1
addressindex=1
timestampindex=1
spentindex=1

EOF


echo "---------------"
# start block explorer
echo "To start the block explorer, from within the zcash-explorer directory issue the command:"
echo " nvm use v4; ./node_modules/bitcore-node-zcash/bin/bitcore-node start"
