#!/bin/bash
sed "s/BUILD_NUMBER/$1/g" deployment.yml > deployment_buildversion.yml
sed "s/BUILD_NUMBER/$1/g" pod-definition.yml > pod-definition_buildversion.yml