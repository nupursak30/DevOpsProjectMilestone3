FROM node:9.10 AS CBGit

WORKDIR /usr/src/Test1

RUN git clone https://github.com/chrisparnin/checkbox.io.git

WORKDIR checkbox.io/server-side/site/

RUN npm install && npm install -g forever
EXPOSE 3002
CMD ["npm","start"]

FROM nginx:1.13 AS CBnginx

WORKDIR /usr/src/nginxTest

COPY --from=CBGit /usr/src/Test1/checkbox.io ./checkbox.io

WORKDIR checkbox.io/local-conf

RUN cp nginx.conf /etc/nginx/nginx.conf && chmod 444 /etc/nginx/nginx.conf \
    && sed -i 's/Users\/gameweld\/bitbucket\/checkbox.io/usr\/src\/nginxTest/' default \
    && mkdir /etc/nginx/sites-available \
    && cp default /etc/nginx/sites-available/default && chmod 444 /etc/nginx/sites-available/default \
    && cat /etc/nginx/sites-available/default