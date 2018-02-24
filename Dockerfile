FROM registry.docker-cn.com/library/alpine
ENV PYTHON_VERSION=2.7.14-r2
ENV PY_PIP_VERSION=9.0.1-r1
ENV BUILD_DEPS="gettext"  \
    RUNTIME_DEPS="libintl"
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk update && apk add -u python=$PYTHON_VERSION py-pip=$PY_PIP_VERSION
RUN apk --update add git privoxy openssl-dev libsodium
RUN set -x && \
    apk add --update $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps
RUN pip install git+https://github.com/shadowsocks/shadowsocks.git@master
COPY ./ss.json.template /ss.json.template
COPY ./run.sh /run.sh
RUN chmod +x /run.sh
COPY ./privoxy-config /etc/privoxy/config
EXPOSE 8080 8118 1080
ENTRYPOINT /run.sh