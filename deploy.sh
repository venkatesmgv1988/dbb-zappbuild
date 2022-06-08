#! /bin/sh
## GitLab/Azure/Jenkins DBB Demo- UCD Buztool v1.3 (njl)
. $HOME/.profile
ucd_version=$1
ucd_Component_Name=$2
MyWorkDir=$3
artifacts=$(ls -d $MyWorkDir/dbb-logs/build*)
echo "**************************************************************"
echo "**     Started:  UCD Publish on HOST/USER: $(uname -Ia) $USER"
echo "**                                   Version:" $ucd_version
echo "**                                 Component:" $ucd_Component_Name
echo "**                                   workDir:" $MyWorkDir
echo "**                         DBB Artifact Path:" $artifacts

buzTool=/u/ucd/v7.0.4/bin/buztool.sh

groovyz $3/deploy.groovy -b $buzTool -w $artifacts -c $ucd_Component_Name -v $ucd_version