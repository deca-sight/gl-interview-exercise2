#cloud-config
hostname: web-asg
packages:
  - httpd
  - mod_ssl
  - openssl

runcmd:
  # Enable repositories and packages
  - dnf config-manager --set-enabled AppStream
  - dnf install -y httpd mod_ssl openssl python3 python3-pip jq unzip

  - curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
  - unzip /tmp/awscliv2.zip -d /tmp
  - /tmp/aws/install
  - export PATH=$PATH:/usr/local/bin

  - pip3 install boto3

  # Disable port 80 (comment Listen 80)
  - sed -i 's/^Listen 80/#Listen 80/' /etc/httpd/conf/httpd.conf

  # Create self-signed certificates
  - mkdir -p /etc/pki/tls/certs /etc/pki/tls/private
  - sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/pki/tls/private/selfsigned.key -out /etc/pki/tls/certs/selfsigned.crt -subj "/C=AR/ST=CABA/L=BuenosAires/O=MyCompany/OU=IT/CN=localhost"

  - sudo sed -i 's|^SSLCertificateFile.*|SSLCertificateFile /etc/pki/tls/certs/selfsigned.crt|' /etc/httpd/conf.d/ssl.conf
  - sudo sed -i 's|^SSLCertificateKeyFile.*|SSLCertificateKeyFile /etc/pki/tls/private/selfsigned.key|' /etc/httpd/conf.d/ssl.conf

  # Ensure Listen 443 is present
  - grep -q "^Listen 443" /etc/httpd/conf.d/ssl.conf || echo "Listen 443" >> /etc/httpd/conf.d/ssl.conf

  # Enable access to DocumentRoot
  - sudo sed -i '/<VirtualHost _default_:443>/,/<\/VirtualHost>/ s|</VirtualHost>|<Directory "/var/www/html">\nOptions Indexes FollowSymLinks\nAllowOverride None\nRequire all granted\n</Directory>\n</VirtualHost>|' /etc/httpd/conf.d/ssl.conf

  # Create test index.html file
  - echo "Hello Coalfire" > /var/www/html/index.html

  # Enable and restart Apache
  - systemctl enable httpd
  - systemctl restart httpd
