#!/bin/bash

read -p "enter org alias : " ORG_ALIAS
read -p "enter manifest file path : " MANIFEST_FILE_PATH
read -p "enter Test Level ( NoTestRun,RunSpecifiedTests,RunLocalTests ) : " TEST_LEVEL

# echo "Enter org alias is ${ORG_ALIAS}"
# echo "Enter manifest file path is : ${MANIFEST_FILE_PATH}"
# echo "Enter Test Level is : ${TEST_LEVEL}"

# validate user input 
if [ -z $ORG_ALIAS ];
then 
   echo "Org alias is Empty "
   exit 1
fi

if [ ! -f $MANIFEST_FILE_PATH ];
then 
    echo "enter manifest file path not exists"
    exit 1
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

# check salesforce cli is installed or not
if ! command -v sfdx &> /dev/null
then
    echo "Salesforce CLI (sfdx) could not be found, please install Salesforce
    CLI first."
    exit 1
fi

# The user is authenticated to the specified org
if sf org list | grep "$ORG_ALIAS" ; then
    echo
    echo "Org '$ORG_ALIAS' validate successfully."
else
    echo "Failed Org Validation ."
fi


# The selected test level is valid.
if [ $TEST_LEVEL == "NoTestRun" ] || [ $TEST_LEVEL == "RunSpecifiedTests" ] || [ $TEST_LEVEL == "RunLocalTests" ];
then 
    echo "Test Level is correct"
else 
   echo "Please enter correct Test level"
   exit 1
fi

# perform validatin to org --dry-run

if  [ $TEST_LEVEL == "RunSpecifiedTests" ];
then
    VALIDATION_RESULT=$(sf project deploy start -x "$MANIFEST_FILE_PATH" --dry-run --test-level RunSpecifiedTests --tests "$TEST_CLASS" --target-org "$ORG_ALIAS" --ignore-warnings --verbose --json) 

    echo "$VALIDATION_RESULT"

    if echo "$VALIDATION_RESULT" | grep -q '"status": 0';
    then 
        echo "validation completed "
        read -p " if you want to deploy y\n: " confirmation
        if [ $confirmation == "y" ]; 
        then
            sf project deploy start -x "$MANIFEST_FILE_PATH" --test-level RunSpecifiedTests --tests "$TEST_CLASS" --target-org "$ORG_ALIAS" --ignore-warnings --verbose > log.txt 
        else
           exit 1
        fi
    else
       echo "dry run not successfully"
       exit 1
    fi
fi

if  [ $TEST_LEVEL == "NoTestRun" ] || [ $TEST_LEVEL == "RunLocalTests" ];
then
    VALIDATION_RESULT=$(sf project deploy start -x "$MANIFEST_FILE_PATH" --dry-run --test-level "$TEST_LEVEL" --target-org "$ORG_ALIAS" --ignore-warnings --verbose --json) 

    echo "$VALIDATION_RESULT"

    if echo "$VALIDATION_RESULT" | grep -q '"status": 0';
    then 
        echo "validation completed "
        read -p " if you want to deploy y\n: " confirmation
        if [ $confirmation == "y" ]; 
        then
            sf project deploy start -x "$MANIFEST_FILE_PATH" --dry-run --test-level "$TEST_LEVEL" --target-org "$ORG_ALIAS" --ignore-warnings --verbose --json > log.txt 
        else
           exit 1
        fi
    else
       echo "dry run not successfully"
    fi
fi
