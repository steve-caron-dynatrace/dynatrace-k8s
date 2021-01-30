#!/bin/bash

PWD=$(pwd)
cd ../dynatrace/alerting
./delete-alerting-profiles.sh
./create-alerting-profiles.sh
cd $PWD
