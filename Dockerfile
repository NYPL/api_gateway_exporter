FROM ruby:2.4.4-jessie AS production

RUN apt-get update

ARG SSH_PRIVATE_KEY
ARG GIT_USERNAME
ARG GIT_USER_EMAIL

# The directory where EXPORT_GIT_URL will be cloned into
RUN mkdir -p /opt/git_working_directory
COPY . /opt/api_gateway_exporter
WORKDIR /opt/api_gateway_exporter

RUN gem install bundler
RUN bundler install --without test development

# Set up SSH keys
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" | base64 -w 0 -i --decode > /root/.ssh/id_rsa
RUN chmod 400 /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts
RUN /usr/bin/ssh-keyscan github.com >> /root/.ssh/known_hosts

# Setup Git
RUN /usr/bin/git config --global user.name "${GIT_USERNAME}"
RUN /usr/bin/git config --global user.email "${GIT_USER_EMAIL}"

CMD ["./bin/export.rb"]

FROM production AS development

# Install development dependencies
RUN cd /opt/api_gateway_exporter && bundle install --with test development

# These will be mounted from developers' localhosts in dockerfile-yml
RUN rm -rfd /opt/api_gateway_exporter
RUN rm -rfd /root/.ssh/
