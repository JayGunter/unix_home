#!/bin/bash

eval cd \$$1
ts=`date +%y%m%d_%H%M%S`

jar cvf $BAP/$1/$ts.zip \
    AndroidManifest.xml \
    project.properties \
    res/ \
    src
