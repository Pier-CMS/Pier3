#!/usr/bin/bash
wget -O- https://get.pharo.org/90+vm | bash
./pharo --headless Pharo.image ./scripts/runTests.st

FILE=/tmp/result.txt
if [ ! -f "$FILE" ]; then
 echo "ERROR: $FILE does not exists!"
 exit 1
fi

# Print the result of the tests
cat $FILE

if grep -q ERROR "$FILE"; then
 echo "SOME ERRORS!"
 exit 1
else
 echo "ALL TEST PASSED"
 exit 0
fi
