#!/bin/bash
VERSION=0.1
SELF_NAME=`basename "$0"`

function startHummingbirdMiner() {
  echo "Start hummingbird miner"
  docker-compose up
}

function stopHummingbirdMiner() {
  echo "Stop hummingbird miner"
  docker-compose down
}

function checkOriginUpdate() {
  SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)

  git fetch

  HEADHASH=$(git rev-parse HEAD)
  UPSTREAMHASH=$(git rev-parse main@{upstream})

  if [ "$HEADHASH" != "$UPSTREAMHASH" ]
  then
  # stop docker-compose first
    echo "Do self update"
    stopHummingbirdMiner
    git stash
    git merge '@{u}'
    chmod +x ${SELF_NAME}
    exec ./${SELF_NAME}
  fi
}
echo "test for git update"
echo ${SELF_NAME}
checkOriginUpdate
startHummingbirdMiner
