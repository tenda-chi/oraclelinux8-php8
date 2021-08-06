FROM oraclelinux:8

RUN yum clean all && \
    yum update -y

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-8.rpm

# sqlserver odbc
RUN yum install -y http://packages.microsoft.com/rhel/8/prod/packages-microsoft-prod.rpm
RUN ACCEPT_EULA=Y yum -y install msodbcsql17 unixODBC unixODBC-devel

RUN yum install -y zip unzip less which libtool net-tools git gcc gcc-c++ make procps-ng
RUN yum install -y openssh-server openssh-clients passwd
RUN yum install -y httpd mod_ssl

RUN yum config-manager --set-enabled remi
RUN yum module -y reset php
RUN yum module -y install php:remi-8.0

RUN yum --enablerepo=epel,remi install -y php php-common php-devel php-cli php-mhash php-gd php-mbstring php-mysqlnd php-pdo \
        php-pear php-soap php-xml php-zip php-odbc php-sqlsrv

# pecl
RUN pecl install xdebug redis

# composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# nodejs
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash -
RUN yum install -y nodejs

RUN yum clean all

RUN openssl req -x509 -nodes -days 3650 \
	 -subj "/C=JP/ST=Tokyo/O=Tenda, Inc./CN=mdb.localdocker" \
	 -newkey rsa:2048 \
	 -keyout /etc/pki/tls/private/localhost.key \
	 -out /etc/pki/tls/certs/localhost.crt

# RUN localectl set-locale LANG=ja_JP.UTF-8
# RUN timedatectl set-timezone Asia/Tokyo

EXPOSE 22 80 443

RUN systemctl enable httpd
RUN systemctl enable sshd.service
RUN echo "tenda" | passwd --stdin root

CMD ["/sbin/init"]
