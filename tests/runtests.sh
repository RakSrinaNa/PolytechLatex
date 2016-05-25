#!/bin/bash

# Absolute path to this script.
SCRIPT=$(readlink -f $0)
# Absolute path this script 
SCRIPTPATH=`dirname $SCRIPT`

cd "$SCRIPTPATH"

find . -maxdepth 1 -mindepth 1 -type d | while read TESTDIR; do
    echo -e "\e[93m"
    echo -n "Running test $TESTDIR : "
    cd "$SCRIPTPATH/$TESTDIR"
    ln -sf ../../polytech
    rm -f test-latexmk.log
    latexmk -gg -pdf -silent test.tex >> test-latexmk.log 2>> test-latexmk.log
    result=$?
    
    if [ -n "$(echo $TESTDIR | grep -i mustfail)" ]; then
	if [ $result = 0 ]; then
	    result=1
	else
	    result=0
	fi
    fi

    if [ $result = 0 ]; then
	echo -e "\e[92mOK\e[39m\n"
	latexmk -C > /dev/null 2>/dev/null
    else
	echo -e "\e[91mERROR\e[39m\n"
	cat test-latexmk.log
	exit 1
    fi
done