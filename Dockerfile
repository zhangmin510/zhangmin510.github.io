FROM alpine:3.2

MAINTAINER zhangmin.name <zhangmin.name> 

COPY ./package.json /tmp/
WORKDIR /tmp/

# Install Nginx and Node.js env
RUN apk update && \
    apk add nginx && \
    apk add nodejs python make g++ && \
    npm install hexo -g && \
    npm install && \
    apk del make g++ python && \
    rm -rf /var/cache/apk/* && \
    echo "Done"

# Copy blog source

COPY ./ /tmp

RUN hexo generate && \
    cp -a /tmp/index/* /usr/share/nginx/html && \
    cp -a /tmp/blog /usr/share/nginx/html && \
    #rm -rf ./* && \
    ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log && \
    echo "Done"

RUN npm un hexo -g && apk del nodejs
RUN rm -rf /tmp/*

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]