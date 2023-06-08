#!/bin/bash 
# Reina Akiara v.0.1

_INSTALLWP() {
	owner=$(echo -e "$(pwd)" | cut -d "/" -f3)

	if [[ $(id | grep "root" ) ]]; then extra="--allow-root"; else extra=""; fi

	echo -e "[~] Checking WP-CLI.phar is supported or no"
	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	if [[ $(php wp-cli.phar $extra | grep "WP-CLI only works correctly from the command line") ]];
	then
		echo -e "[!] wp-cli not supported!" && exit
	else
		echo -e "[+] wp-cli supported!"
	fi

	echo -e ""
	#	----	VAR		----
	echo -e "[STEP 1]==================================="
	echo ""
	read -p $" [+] Directory name: " dir
	read -p $" [+] DB HOST       : " dbhost
	read -p $" [+] DB NAME       : " dbname
	read -p $" [+] DB USER       : " dbuser
	read -p $" [+] DB PASSWORD   : " dbpass
	read -p $" [+] DB PREFIX     : " dbprefix
	echo ""
	echo -e "[STEP 2]==================================="
	echo ""
	read -p $" [+] URL [e.g:example.com]     : " url
	read -p $" [+] TITLE                     : " title
	read -p $" [+] ADMIN USERNAME            : " username
	#read -p $" [+] ADMIN PASSWORD            : " password
	read -p $" [+] ADMIN EMAIL               : " email

	echo -e "[~] Downloading Wordpress"
	wget -q https://wordpress.org/latest.zip && unzip -q "latest.zip" && mv "wordpress" ${dir} && cd ${dir}
	
	echo -e "[~] Downloading wp-cli.phar..."
	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

	#	Creating config file
	php wp-cli.phar core config --dbhost="${dbhost}" --dbname="${dbname}" --dbuser="${dbuser}" --dbpass="${dbpass}" $extra
	php core install --url="${url}" --title="${title}" --admin_user="${username}" --admin_email="${email}" $extra


	# 	wp core config --dbhost=host.db --dbname=prefix_db --dbuser=username --dbpass=password
	#	wp core install --url=yourwebsite.com --title="Your Blog Title" --admin_name=wordpress_admin --admin_password=4Long&Strong1 --admin_email=you@example.com
}




echo -e "
[+] ===============================

  [1] Install Wordpress & AGC

[+] ===============================
"
read -p $": Select Option : " option

if [[ $option == "1" ]];
	then
		_INSTALLWP 
elif [[ $option == "0" ]];
	then
		exit
else
	echo -e "sams"
fi
