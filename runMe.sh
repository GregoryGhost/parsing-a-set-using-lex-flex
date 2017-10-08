#!/bin/bash
. ./definePath.sh
. ./runUnitTest.sh

mkdir $dirBuild &&
cd $dirBuild &&
cmake .. &&
make &&
cd $dirProject && 
checkLexCalc

# rm -fr $dirBuild
# rm -fr $testLog