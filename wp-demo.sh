#!/bin/bash
clear
figlet CYBERSTORM.MU
echo "Press Enter to continue or Press CTRL-C to exit"
read al
echo 'Installing Requirements for Wordpress....'
echo .
echo .
apt update
apt install nginx
apt install mysql-server
apt install php-fpm
apt install php-mysql
echo Requirements Installed....
echo .
echo .
echo Press Enter To Continue...
read upd
clear
figlet CYBERSTORM.MU
echo -e "\e[4;31m Easily automate your wordpress installation on a server. \e[0m"
echo "Press 1 To  Configure MySQL database "
echo "Press 2 To  Download and configure wordpress"
echo "Press 3 To  Configure NGINX webserver"
echo "Press 4 To  EXIT "
read ch
if [ $ch -eq 1 ];then
clear
echo "Enter your domain name ( if it's locally hosted then just put localhost ) ?"
read dn
echo "Enter the name of your database ?"
read db_name
echo "Enter your username ( Example: username@domainname ) ?"
read username
echo "Enter a password for your database ( Put a good one :P ) ?"
read db_pass
if [ -f /root/.my.cnf ]; then

    mysql -e "CREATE DATABASE ${db_name} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -e "CREATE USER ${username}@${dn} IDENTIFIED BY '${db_pass}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${db_name}.* TO ${username}@${dn};"
    mysql -e "FLUSH PRIVILEGES;"

# If /root/.my.cnf doesn't exist then it'll ask for root password   
else
    echo "Please enter root user MySQL password!"
    echo "Note: password will be hidden when typing"
    read -sp rootpasswd
    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${MAINDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -uroot -p${rootpasswd} -e "CREATE USER ${username}@${dn} IDENTIFIED BY '${db_pass}';"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${db_name}.* TO ${username}@${dn};"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
fi
echo "MySQL Database Configured !"
exit 0
elif [ $ch -eq 2 ];then
clear
echo "Enter the name of your site ( Example: example.com )"
read domain1
wget -c http://wordpress.org/latest.tar.gz
mkdir /var/www/html/$domain1
tar -xzvf latest.tar.gz
cd wordpress
sudo cp -R * /var/www/html/$domain1
cd /var/www/html/$domain1
chown -R www-data:www-data /var/www/html/$domain1
chmod -R 775 /var/www/html/$domain1
mv wp-config-sample.php wp-config.php
nano wp-config.php
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
echo "Done !"
exit 0
elif [ $ch -eq 3 ];then
clear
echo "Enter the name of your site ( Example: example.com )"
read domain
tee $block > /etc/nginx/conf.d/$domain.conf <<EOF
server {
        listen 80;
        listen [::]:80;
        root /var/www/html/$domain;
        index  index.php index.html index.htm;
        server_name $domain www.$domain;

        error_log /var/log/nginx/$domain _error.log;
        access_log /var/log/nginx/$domain _access.log;

        client_max_body_size 100M;
        location / {
                try_files $uri $uri/ /index.php?$args;
        }
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.4-fpm.sock;
                fastcgi_param   SCRIPT_FILENAME $document_root$fastcgi_script_n>
        }
}

EOF
echo "Success !, $domain.conf has been written to /etc/nginx/conf.d "
exit 0
elif [ $ch -eq 4 ];then
clear
figlet CYBERSTORM.MU
exit 0
fi
done
