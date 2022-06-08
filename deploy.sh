#! /bin/sh
## GitLab/Azure/Jenkins DBB Demo- UCD Buztool v1.3 (njl)
. $HOME/.profile

ucd_version=$1

ucd_Component_Name=$2

MyWorkDir=$3

artifacts=$(ls -d $MyWorkDir/dbb-logs/build*)

buzTool=/u/ucd/v7.0.4/bin/buztool.sh

/usr/lpp/IBM/dbb/bin/groovyz $3/deploy.groovy -b $buzTool -c $ucd_Component_Name -v $ucd_version -w $artifacts