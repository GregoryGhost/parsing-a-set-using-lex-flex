#!/bin/bash
. ./definePath.sh

#first argument - name test for lexCalc
function genLogForTest(){
    nameTest=$1
    echo "# $nameTest" >> $testLog &&
    $exeRPN < ./test/$nameTest >> $testLog
}

function checkLexCalc(){
    genLogForTest $intTest
    genLogForTest $doubleTest
    genLogForTest $posTestSet
    genLogForTest $negTestSet

    if diff $trueLog $testLog; then
        echo -e "\033[32mTEST DIFF OUTPUTS COMPLETE: GOOD\033[0m"
    else
        echo -e "\033[31mTEST DIFF OUTPUTS COMPLETE: WTF?!\033[0m"
    fi
}