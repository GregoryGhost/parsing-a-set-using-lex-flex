dirProject=$(pwd)
dirTest="$(pwd)/test"
dirBuild="$(pwd)/build"

testLog="$dirTest/test_output.log"
trueLog="$dirTest/true_output.log"

exeRPN="$dirBuild/src/lexCalc"
negTestSet="negative_test_set.txt"
posTestSet="positive_test_set.txt"
intTest="test_int.txt"
doubleTest="test_double.txt"