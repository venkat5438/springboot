#!/bin/bash
sed "s/BUILD_NUMBER/$1/g" deployment.yml > deployment_buildversion.yml