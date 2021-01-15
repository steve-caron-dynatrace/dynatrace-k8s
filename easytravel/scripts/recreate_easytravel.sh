#!/bin/sh

echo "Recreating easyTravel"
./delete_easytravel.sh
echo "Waiting for 120 seconds"
sleep 120
./create_easytravel.sh
