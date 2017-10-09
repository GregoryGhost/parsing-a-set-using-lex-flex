#!/bin/bash
. ./scripts/definePath.sh
. ./scripts/runUnitTest.sh

mkdir $dirBuild &&
cd $dirBuild &&
cmake .. &&
make &&
cd $dirProject && 
checkLexCalc &&
rm -fr $dirBuild &&
rm -fr $testLog
