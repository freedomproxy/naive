FROM adguard/adguardhome

ADD rootCA.crt /usr/local/share/ca-certificates
RUN update-ca-certificates