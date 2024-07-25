ARG ALPINE_TAG=3.20
ARG JELLYSEER_VER=1.9.2

FROM node:alpine AS builder

ARG JELLYSEER_VER
ENV COMMIT_TAG="${JELLYSEER_VER}" \
    NODE_OPTIONS=--openssl-legacy-provider

### install jellyseerr
WORKDIR /output/jellyseerr
RUN apk add --no-cache git; \
    git clone https://github.com/Fallenbagel/jellyseerr.git --branch v${JELLYSEER_VER} /jellyseerr-src; \
    cp -a /jellyseerr-src/.eslintrc.js /jellyseerr-src/babel.config.js /jellyseerr-src/next-env.d.ts \
        /jellyseerr-src/next.config.js /jellyseerr-src/ormconfig.js /jellyseerr-src/package.json \
        /jellyseerr-src/postcss.config.js /jellyseerr-src/stylelint.config.js /jellyseerr-src/tailwind.config.js \
        /jellyseerr-src/tsconfig.json /jellyseerr-src/yarn.lock /jellyseerr-src/overseerr-api.yml .; \
    yarn install --frozen-lockfile --network-timeout 1000000; \
    cp -a /jellyseerr-src/server /jellyseerr-src/src /jellyseerr-src/public .; \
    yarn run build; \
    yarn install --production --ignore-scripts --prefer-offline; \
    echo "{\"commitTag\": \"${JELLYSEER_VER}\"}" > committag.json; \
    ln -s /config config; \
    rm -rf src server .eslintrc.js babel.config.js next-env.d.ts next.config.js postcss.config.js \
        stylelint.config.js tailwind.config.js tsconfig.json yarn.lock

COPY *.sh /output/usr/local/bin/
RUN chmod +x /output/usr/local/bin/*.sh

#============================================================

FROM loxoo/alpine:${ALPINE_TAG}

ARG JELLYSEER_VER
ENV SUID=953 SGID=953

LABEL org.label-schema.name="jellyseerr" \
      org.label-schema.description="Request management and media discovery tool for the Jellyfin ecosystem" \
      org.label-schema.url="https://github.com/fallenbagel/jellyseerr" \
      org.label-schema.version=${JELLYSEER_VER}

COPY --from=builder /output/ /

WORKDIR /jellyseerr
RUN apk add --no-cache yarn

VOLUME ["/config"]

EXPOSE 5055/TCP

HEALTHCHECK --start-period=10s --timeout=5s \
    CMD wget -qO /dev/null "http://127.0.0.1:5055/api/v1/status"

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["yarn", "start"]
