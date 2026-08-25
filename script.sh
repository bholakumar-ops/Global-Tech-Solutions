#!/bin/bash

read -p "enter org alias : " ORG_ALIAS
read -p "enter manifest file path : " MANIFEST_FILE_PATH
read -p "enter Test Level ( NoTestRun,RunSpecifiedTests,RunLocalTests ) : " TEST_LEVEL

echo "Enter org alias is ${ORG_ALIAS}"
echo "Enter manifest file path is : ${MANIFEST_FILE_PATH}"
echo "Enter Test Level is : ${TEST_LEVEL}"

# validate user input 
if [ -z $ORG_ALIAS ];
then 
   echo "Org alias is Empty "
   exit 1
fi

if [ ! -f $MANIFEST_FILE_PATH ];
then 
    echo "enter manifest file path not exists"

fi

if [ -z $TEST_LEVEL ];
then 
   echo "Test Level is Empty "
   exit 1
fi

if [ $TEST_LEVEL == "RunSpecifiedTests" ];
then 
    read -p "enter apex test class for run specified : " TEST_CLASS
    if [ -z $TEST_CLASS ];
    then 
        echo "Test class is Empty "
        exit 1
    fi
fi
echo "$TEST_CLASS"