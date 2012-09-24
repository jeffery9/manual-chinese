#!/bin/bash
#set -e
#set -x

#DIR=$(readlink -f $(dirname $0)/..)
DIR=$(pwd)
#echo $DIR

# Uploads different formats of the manual to a public server.


# Which version the documentation is now.
#VERSION=$(cat $DIR/target/classes/version)

DOCS_SERVER='tony@ali'
ROOTPATHDOCS='/home/tony/project/php/neo4j/docs/zh_cn'

#echo "VERSION = $VERSION"

# Create initial directories
# ssh $DOCS_SERVER mkdir -p $ROOTPATHDOCS/lab/manual-chinese

# Copy artifacts
rsync -ru  --delete "$DIR/target/chunked-offline/" $DOCS_SERVER:$ROOTPATHDOCS


echo Apparently, successfully published to $DOCS_SERVER.

