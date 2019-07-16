FROM frolvlad/alpine-glibc

ARG APPPORT
ENV APPPORT ${APPPORT:-3000}

EXPOSE 80 3000 ${APPPORT}

ENV BUILD_PACKAGES="python make gcc g++ git curl libarchive-tools bzip2 bash libuv" \
    NODE_ENV=production

WORKDIR /

RUN apk add --update --no-cache  ${BUILD_PACKAGES}
RUN export tar='bsdtar'
# Custom built version of mongodump (bc. alpine doesn't have v4)
COPY ./mongodump /usr/bin/mongodump

RUN curl https://install.meteor.com/ | sh
RUN curl -fL https://raw.githubusercontent.com/orctom/alpine-glibc-packages/master/usr/lib/libstdc++.so.6.0.21 -o /usr/lib/libstdc++.so.6
ENV METEOR_ALLOW_SUPERUSER=true

ONBUILD COPY app /app

WORKDIR /app
ARG ONBUILDSH
ENV ONBUILDSH ${ONBUILDSH:-du -hd1}
RUN ${ONBUILDSH}

#RUN cd /app && meteor update
#RUN cd /app && meteor npm install --save
#RUN meteor npm install --production
#RUN meteor build /build --architecture os.linux.x86_64

COPY scripts /scripts

#ONBUILD RUN sh /scripts/build.sh
#ONBUILD RUN sh /scripts/rebuild_bin_npm_modules.sh
#ONBUILD RUN sh /scripts/clean.sh

ENTRYPOINT sh /scripts/dev.sh
