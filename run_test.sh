#!/bin/bash

YOUR_ASM=$1
TEST=$2
TEST_NAME=$(basename -- "${TEST}")
as "$YOUR_ASM" "$TEST" -o merged.o

if [ -f "merged.o" ]; then
	ld merged.o -o merged.out
	if [ -f "merged.out" ]; then
		timeout 60s ./merged.out | tee tempOutput.txt
		if [ $? -eq 0 ]; then
			if cmp -s "$TEST.out" "tempOutput.txt"; then
    			echo "${YOUR_ASM} tested with ${TEST_NAME}: PASS"
			else
    			echo "${YOUR_ASM} tested with ${TEST_NAME}: FAIL"
			# echo "${YOUR_ASM} tested with ${TEST_NAME}: PASS"
			STATUS=0
			fi
		else
			echo "${YOUR_ASM} tested with ${TEST_NAME}: FAIL"
			STATUS=1
		fi
	else
		echo "${YOUR_ASM} could not be created (ld stage) with ${TEST_NAME}: FAIL"
		STATUS=1	
	fi
else
	echo "${YOUR_ASM} could not be created (as stage) with ${TEST_NAME}: FAIL"
	STATUS=1		
fi

rm merged.*
rm tempOutput.txt
exit ${STATUS}