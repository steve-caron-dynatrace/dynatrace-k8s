#!/bin/bash

PWD=$(pwd)
cd ../dynatrace/management-zones
./create-management-zones.sh
cd $PWD