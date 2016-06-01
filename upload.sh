#!/bin/bash


NEXUS_REPOSITORY="https://nexus.projectsforge.org/repository/gitlab_public_artifacts"

PROJECT_PATH=$(echo ${CI_BUILD_REPO} | sed 's~http[s]*://[^/]*\(.*\).git$~\1~')

FILES_VERSION=$(grep '\\def\\polytechfileversion' polytech/polytech.cls | sed 's~\\def\\polytechfileversion{\(.*\)}~\1~' )
FILES_DATE=$(grep '\\def\\polytechfiledate' polytech/polytech.cls | sed 's~\\def\\polytechfiledate{\(.*\)}~\1~' | sed 's~/~.~g')

echo curl -v -u $NEXUS_USER:$NEXUS_PASSWORD --upload-file polytech.zip $PROJECT_PATH/$CI_BUILD_REF_NAME/polytech-$FILES_VERSION-${FILES_DATE/\//.}.zip

