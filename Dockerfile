FROM ubuntu

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y mysql-server mysql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./smart_office_dev.sql /tmp/

RUN service mysql start && \
    mysql -u root -e "CREATE USER 'so_user'@'localhost' IDENTIFIED BY 'scrunch12';" && \
    mysql -u root -e "ALTER USER 'so_user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'scrunch12';" && \
    mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'so_user'@'localhost';" && \
    mysql -u root -e "UPDATE mysql.user SET Host='172.17.0.1' WHERE Host='localhost' AND User='so_user';" && \
    mysql -u root -e "FLUSH PRIVILEGES;" && \
    mysql -u root -e "CREATE DATABASE smartoff;" 


RUN service mysql start && \
    mysql -u so_user -pscrunch12 smartoff < /tmp/smart_office_dev.sql


EXPOSE 3306


CMD ["mysqld", "--datadir=/var/lib/mysql", "--user=mysql", "--port=3306", "--bind-address=0.0.0.0", "--default-authentication-plugin=mysql_native_password", "--character-set-server=utf8mb4", "--collation-server=utf8mb4_unicode_ci"]

