#!/bin/bash

FRONTEND_URL=$(grep "PROD_FRONTEND_URL=" configs.txt | sed 's~PROD_FRONTEND_URL=[ \t]*~~')
USERNAME_PRE=$(grep "SOCKSHOP_USERNAME_PRE=" configs.txt | sed 's~SOCKSHOP_USERNAME_PRE=[ \t]*~~') 
PASSWORD=$(grep "SOCKSHOP_PASSWORD=" configs.txt | sed 's~SOCKSHOP_PASSWORD=[ \t]*~~') 
EMAIL=$(grep "SOCKSHOP_EMAIL=" configs.txt | sed 's~SOCKSHOP_EMAIL=[ \t]*~~') 
FIRSTNAME=$(grep "SOCKSHOP_FIRSTNAME=" configs.txt | sed 's~SOCKSHOP_FIRSTNAME=[ \t]*~~') 
LASTNAME_PRE=$(grep "SOCKSHOP_LASTNAME_PRE=" configs.txt | sed 's~SOCKSHOP_LASTNAME_PRE=[ \t]*~~')

for i in {1..4}
do
	USERNAME=$USERNAME_PRE$i
	LASTNAME=$LASTNAME_PRE$i

	curl "$FRONTEND_URL/register" -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Content-Type: application/json; charset=utf-8' \
	       	-H 'X-Requested-With: XMLHttpRequest' -H "Origin: $FRONTEND_URL" -H 'Connection: keep-alive' -H "Referer: $FRONTEND_URL/" -H 'Pragma: no-cache' \
	       	-H 'Cache-Control: no-cache' --data "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\",\"email\":\"$EMAIL\",\"firstName\":\"$FIRSTNAME\",\"lastName\":\"$LASTNAME\"}"; echo ""
done



