FROM alpine:3.20.3

RUN apk update && apk add --no-cache nginx openssl

RUN addgroup -S data-buddies && adduser -S data-buddies -G data-buddies

RUN mkdir -p /etc/nginx /etc/nginx/ssl 

COPY conf/nginx.conf /etc/nginx/nginx.conf
RUN chmod 644 /etc/nginx/nginx.conf

RUN openssl req -x509 -newkey rsa:2048 -sha256 -keyout /etc/nginx/ssl/ssl.key \
	-out /etc/nginx/ssl/ssl.crt -days 365 -nodes \
	-subj "/C=FI/ST=Helsinki/L=Helsinki/O=42/OU=Hive/CN=vkettune.42.fr"

RUN chmod 644 /etc/nginx/ssl/ssl.crt /etc/nginx/ssl/ssl.key

EXPOSE 443

ENTRYPOINT [ "nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;" ]