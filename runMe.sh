#!/bin/bash
. ./definePath.sh
. ./runUnitTest.sh

mkdir $dirBuild &&
cd $dirBuild &&
cmake .. &&
make &&
cd $dirProject && 
<<<<<<< HEAD
checkLexCalc

# rm -fr $dirBuild
# rm -fr $testLog
=======
checkLexCalc &&
rm -fr $dirBuild &&
rm -fr $testLog
>>>>>>> dev1
