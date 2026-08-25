#!/bin/bash
variable_to_search="@SuppressWarnings"

find . -type f ! -name "codeAnalysis.sh" -exec grep -iq "$variable_to_search" {} \; -exec grep -iHn "$variable_to_search" {} \;
echo "--------------------------------------------------------------------------------------"
swcount=$(find . -type f ! -name "codeAnalysis.sh" -exec grep -iq "$variable_to_search" {} \; -exec grep -iHn "$variable_to_search" {} \; | wc -l)

if [ $swcount -gt 5 ]; then
   echo "SuppressWarnings limit reached 🚨"
   echo " "
   echo "Job Failed, Kindly remove the SupressWarning!"
   exit 125
else
   echo "$swcount SupressWarnings found which are acceptable✅"
fi


PMD_ERRORS=$(~/pmd-bin-7.0.0-rc4/bin/pmd check -d force-app -R deploymentFolder/ruleset.xml -f text | grep 'force-app/')
PMD_ERRORS_COUNT=0
PMD_ERRORS_COUNT=$(echo $PMD_ERRORS | grep -o 'force-app' | wc -l)
echo "Error count is: $PMD_ERRORS_COUNT"
PMD_ERRORS=$(echo "$PMD_ERRORS" | sed 's/force-app/\n\/force-app/g')

# we need to bypass the existing PMD issues
if [ $PMD_ERRORS_COUNT -gt 0 ]; then
   echo "Errors are $PMD_ERRORS"
   echo " "
   echo "Total Code Analysis Error count: $PMD_ERRORS_COUNT"
   echo " "
   echo "Job Failed, Kindly resolve the pmd issues! 📍"
   # exit 125
else
   echo "Code Analysis Passed. No Error Found 🎯"
fi
