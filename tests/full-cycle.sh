#!/bin/bash

set -e

pushd $(dirname $0) > /dev/null
SCRIPTPATH=$(pwd)
popd > /dev/null
cd $SCRIPTPATH

PUB=$(mktemp pub.$$.XXXXXXXXXX)
PRIV=$(mktemp priv.$$.XXXXXXXXXX)
MSG=$(mktemp msg.$$.XXXXXXXXXX)

cleanup() {
  rm $PUB $PRIV $MSG $MSG.sig
}

trap cleanup SIGHUP SIGINT SIGTERM EXIT

cargo run -- -G -n -p $PUB -s $PRIV
head -c 100 /dev/urandom > $MSG
cargo run -- -S -s $PRIV -m $MSG -x ${MSG}.sig
cargo run -- -V -p $PUB -m $MSG -x ${MSG}.sig
