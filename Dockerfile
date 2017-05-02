FROM nancom/apl-jdk8
MAINTAINER Nancom, https://github.com/nancom/docker-alpine

# Set environment variables
ENV KIBANA_VERSION 5.3.2
ENV PKG_NAME kibana
ENV PKG_PLATFORM linux-x86_64
ENV KIBANA_PKG $PKG_NAME-$KIBANA_VERSION-$PKG_PLATFORM
ENV KIBANA_CONFIG /opt/elk/$PKG_NAME-$KIBANA_VERSION-$PKG_PLATFORM/config/kibana.yml
ENV ELASTICSEARCH_HOST elasticsearch


RUN mkdir -p /opt/elk
RUN adduser -D -h /opt/elk elk

COPY kibana-5.3.2-linux-x86_64.tar.gz /tmp
# Download Kibana
RUN apk add --update ca-certificates wget tzdata nodejs \
    && mkdir -p /opt/elk \
    && tar -xvzf /tmp/$KIBANA_PKG.tar.gz -C /opt/elk \
    && ln -s /opt/elk/$KIBANA_PKG /opt/elk/$PKG_NAME \
    && sed -i "s/localhost/$ELASTICSEARCH_HOST/" $KIBANA_CONFIG \
    && rm -rf /tmp/*.tar.gz /var/cache/apk/* /opt/elk/$KIBANA_PKG/node/ \
    && mkdir -p /opt/elk/$KIBANA_PKG/node/bin/ \
    && ln -s $(which node) /opt/elk/$PKG_NAME/node/bin/node

# Expose
EXPOSE 5601

USER elk

# Working directory
WORKDIR ["/opt/elk/kibana"]
CMD ["/opt/elk/kibana/bin/kibana"]
