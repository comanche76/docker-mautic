FROM mysql:8.0-debian

COPY my.cnf /etc/mysql/conf.d/custom-my.cnf

# Install MYSQL Tuner. Perl script that analyzes your MySQL performance and provides recommendations
RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates wget perl \
    && rm -rf /var/lib/apt/lists/* \
    && wget http://mysqltuner.pl/ -O /usr/local/bin/mysqltuner.pl \
    && wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/basic_passwords.txt -O basic_passwords.txt \
    && wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/vulnerabilities.csv -O vulnerabilities.csv \
    && chmod +x /usr/local/bin/mysqltuner.pl

EXPOSE 3306 33060

CMD ["mysqld"]

