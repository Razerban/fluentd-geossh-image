FROM fluent/fluentd:v1.16-1

# Use root account to use apk
USER root

# Install plugins and their dependencies
# (influxdb issue, see https://github.com/fangli/fluent-plugin-influxdb/issues/110)
RUN apk add --no-cache --update --virtual .build-deps \
                                          build-base \
                                          ruby-dev \
    && fluent-gem install --no-document fluent-plugin-influxdb \
                                        influxdb \
                                        fluent-plugin-multi-format-parser \
                                        fluent-plugin-ipinfo \
                                        fluent-plugin-record-modifier \
    && fluent-gem sources --clear-all \
    && apk del .build-deps \
    && rm -rf /tmp/* \
              /var/tmp/* \
              /usr/lib/ruby/gems/*/cache/*.gem

# Switch to fluent user
USER fluent
