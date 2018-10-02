FROM ruby:2.4.4-jessie AS production

RUN apt-get update
RUN mkdir -p /opt/
COPY . /opt/api_gateway_exporter
WORKDIR /opt/api_gateway_exporter
RUN gem install bundler
RUN bundler install --without test development

CMD ["./bin/export.rb"]

FROM production AS development

# Install development dependencies
RUN cd /opt/api_gateway_exporter && bundle

# It will be mounted from localhost in dockerfile-yml
RUN rm -rfd /opt/api_gateway_exporter
