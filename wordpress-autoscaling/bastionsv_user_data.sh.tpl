#!/bin/bash -x

yum -y update

# install cloudwatch agent with default configuration
rpm -Uvh https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c default -s

# install package for wordpress
amazon-linux-extras install -y php7.3
yum install -y httpd mysql amazon-efs-utils

mkdir -p /var/www/wordpress

# make systemd unit file for efs mount
cat << EOS | sudo tee /etc/systemd/system/var-www-wordpress.mount
[Unit]
Description=Things devices
After=network.target

[Mount]
What=${EFSFileSystem}.efs.${region}.amazonaws.com:/
Where=/var/www/wordpress
Type=nfs
Options=nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2

[Install]
WantedBy=multi-user.target
Before=httpd
EOS

systemctl daemon-reload
systemctl enable var-www-wordpress.mount
systemctl start var-www-wordpress.mount

# definition for not systemd
# mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${EFSFileSystem}.efs.${region}.amazonaws.com:/ /var/www/wordpress
df

mkdir -p /var/www/wordpress/wproot

# allow .htaccess
cat << EOS | sudo tee /etc/httpd/conf.d/wordpress.conf
ServerName 127.0.0.1:80
DocumentRoot /var/www/wordpress/wproot
<Directory "/var/www/wordpress/wproot">
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
EOS


# get wordpress module
# install wp-cli
curl -o /bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x /bin/wp

cd /var/www/wordpress/wproot

wpinstalled=0
wp core is-installed --allow-root || wpinstalled=$?
echo $wpinstalled

# if not installed wp. install wp
if [ $wpinstalled -ne 0 ]; then
    wp core download --locale=ja --allow-root

    wp core config --dbname=${RDSInstanceIdentifier} --dbuser=${RDSMasterUserName} --dbpass=${RDSMasterUserPW} --dbhost=${EndpointAddress} --allow-root

    wp db create --allow-root

    # exec wp core install
    wp core install --url=${WebSVALBDNSName} --title=${WordPressTitle} --admin_name=${WordPressAdminName} --admin_password=${WordPressAdminPassword} --admin_email=${WordPressAdminEmail}  --skip-email --allow-root

    chown -R apache:apache /var/www/wordpress/wproot
    chmod u+wrx /var/www/wordpress/wproot/wp-content/*

    # install and activate plugin
    wp plugin install akismet --activate
    wp plugin install contact-form-7 --activate
    cd /var/www/wordpress/wproot/wp-content/plugins
    curl -o mts-simple-booking-c.zip http://mtssb.mt-systems.jp/download/mts-simple-booking-c-1.4.1.zip?nonce=6cfe904778
    unzip mts-simple-booking-c.zip
    wp plugin activate mts-simple-booking-c

fi



systemctl restart httpd
systemctl enable httpd
