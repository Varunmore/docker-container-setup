#!/bin/bash

# Select purpose of Container
echo "Purpose of container: 
1. web hosting
2. bash shell
3. quit"

sleep 4
echo "1. Enter option number: "
read cont


# Exit the program
if [[ $cont -eq 3 ]]; then
	echo "Exiting..."
	exit 0
fi

sleep 5

# Creating web hosting container 
if [[ $cont -eq 1 ]]; then
	# Selecting base image
	echo "2. Enter a base image for container (eg: nginx, node, httpd): "
	read base
	
	sleep 4
	echo "3. Enter the path of web files: "
	read path


	if [[ $base == "nginx" ]]; then
	       	echo "FROM $base\nCOPY $path /usr/share/nginx/html\nEXPOSE 80\nCMD [\"nginx\", \"-g\", \"demon off;\"]" > dockerfile
	

	elif [[ $base == "node" ]]; then
	       	echo "FROM $base\nWORKDIR /app\nCOPY $path . \nRUN npm install\nEXPOSE 80\nCMD [\"npm\", \"start\"]" > dockerfile

	
	else 
		echo "FROM apache\nCOPY $path /var/www/http/html\nEXPOSE 80\nCMD [\"httpd-foreground\"]" > dockerfile

	fi

	sleep 4
	echo "4. Building Docker Image"
	docker build -t "base-web" . 2&>1 | tee build.log 
	if [[ $? -ne 0 ]]; then
		echo "Docker build failed.. Check build.log Exiting...."
		exit 1
	fi
	
	sleep 4
	echo "5. Running Docker Container"
	docker run -d --rm -p 8080:80 --name "base-web" $base || { echo "Docker run failed! Exiting..."; exit 1;}
	
	sleep 4
	echo "6. Website running on localhost:8080"

# Creating bash shell for selected base
elif [[ $cont -eq 2 ]]; then
	 # selecting base image
	 echo "2.Enter a base image for container (eg: ubuntu, alipne, etc.): "
	 read base
	 
	 sleep 4
	 echo "3. Creating Docker Image"
	 docker pull $base &> /dev/null
         
	 sleep 4
	 echo "4. Running Docker Container"
	 docker run -it --rm --name "$base" $base 

# Exiting program  
else
	echo "Invalid Option. Exiting..."
	exit 1
fi	
