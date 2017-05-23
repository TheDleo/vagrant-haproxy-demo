#!/bin/bash

if [ ! -f /etc/network/if-up.d/custom-network-config ]; then

  # Install apache and php
  /usr/bin/apt-get update
  /usr/bin/apt-get -y install apache2 php5 libapache2-mod-php5
  
  cat > /var/www/html/index.php <<EOD
<?php
        session_start();
        \$_SESSION['favoriteorg'] = 'FH';
?>
<html><head><title>${HOSTNAME}</title></head><body><h1>${HOSTNAME}</h1>
<p>This is the default web page for ${HOSTNAME}.</p>
</body></html>
EOD

  # Log the X-Forwarded-For
  perl -pi -e  's/^LogFormat "\%h (.* combined)$/LogFormat "%h %{X-Forwarded-For}i $1/' /etc/apache2/apache2.conf
  /usr/sbin/service apache2 restart

fi

