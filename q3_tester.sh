#!/bin/bash


for i in {1..6}; do
	as ex3.asm q3_tests/test${i} -o merged.o
	
	if [ -f "merged.o" ]; then
		ld merged.o -o merged.out
		if [ -f "merged.out" ]; then
			timeout 60s ./merged.out	
			if [ $? -eq 0 ]; then
				echo "Question 3 tested with test ${i}: PASS"
				STATUS=0
			else
				echo "Question 3 tested with test ${i}: FAIL"
				STATUS=1
			fi
		else
			echo "Question 3 could not be created (ld stage) with test ${i}: FAIL"
			STATUS=1	
		fi
	else
		echo "Question 3 could not be created (as stage) with test ${i}: FAIL"
		STATUS=1		
	fi
done

rm merged.*
exit ${STATUS}
