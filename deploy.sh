#!/bin/bash

# extract project path in gitlab
PROJECT_PATH=$(echo ${CI_BUILD_REPO} | sed "s~http[s]*://[^/]*\(.*\).git$~\1~")
# where is the raw nexus repository
NEXUS_REPOSITORY="https://nexus.projectsforge.org/repository/gitlab_public_artifacts"
# compute the base url including branch
BASEURL="$NEXUS_REPOSITORY/$PROJECT_PATH/$CI_BUILD_REF_NAME/"

# Extract version and date from LaTeX document class
FILES_VERSION=$(grep '\\def\\polytechfileversion' polytech/polytech.cls | sed 's~\\def\\polytechfileversion{\(.*\)}~\1~' )
FILES_DATE=$(grep '\\def\\polytechfiledate' polytech/polytech.cls | sed 's~\\def\\polytechfiledate{\(.*\)}~\1~' | sed 's~/~.~g')

# Create the archive
ARCHIVE="polytech-$FILES_VERSION-$FILES_DATE.zip"
zip -r $ARCHIVE polytech/

# Upload archive
curl -u $NEXUS_USER:$NEXUS_PASSWORD --upload-file $ARCHIVE $BASEURL/$ARCHIVE

# Retreive archive list
curl -f -u $NEXUS_USER:$NEXUS_PASSWORD $REPOSITORY/list.txt 2> /dev/null > oldlist.txt

# Create the new list
echo $ARCHIVE > list.txt

# Check for missing files
cat oldlist.txt | while read f; do
    if [ ! "$ARCHIVE" = "$f" ]; then
	curl -f -u $NEXUS_USER:$NEXUS_PASSWORD $BASEURL/$f
	result=$?
	if [ "$result" = "0" ]; then
    	    echo "Found $f"
    	    echo $f >> list.txt
	else
    	    echo "File $f is missing"
	fi
    fi
done

# Create the index
echo "<html><body><h1>Liste des fichiers disponibles</h1><ul>" > index.html
FIRST=1
cat list.txt | sort -r | while read f; do
    if [ "$FIRST" = "1" ]; then
	FIRST=0
	echo "<li><a href='$f'><b><font color="red">$f</font><b></a></li>" >> index.html
    else
	echo "<li><a href='$f'>$f</a></li>" >> index.html
    fi
done
echo "</ul></body></html>" >> index.html

# Upload the new list.txt
curl -f -u $NEXUS_USER:$NEXUS_PASSWORD --upload-file list.txt $BASEURL/list.txt
# Upload the new index.html
curl -f -u $NEXUS_USER:$NEXUS_PASSWORD --upload-file index.html $BASEURL/index.html



