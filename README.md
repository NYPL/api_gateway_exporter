# API Gateway Exporter

We want to keep the [API gateway configuration](https://docs.aws.amazon.com/cli/latest/reference/apigateway/get-export.html), for each stage, under source control.  
This app can be called by a scheduler and:

1.  Download the API configuration.
2.  Commit it to source control it's changed since the last run.

## Installing / Running Locally

### Installing

1.  `cp .env.example .env` and fill it out.
2.  `docker-compose build`
3.  `docker-compose up`

### Debugging

You can run the container and use pry.

1. To get into the container run `docker-compose run gateway_exporter bash`.  
2. Then, _inside the container_: `cd /opt/api_gateway_exporter && ./bin/export.rb`

### Development vs Production Builds

Development / Local configuration is governed by [docker-compse.yml](./docker-compse.yml)

## Deployment

### Required Build ARGs

| Name            | Description                                                                                        |
|:----------------|:---------------------------------------------------------------------------------------------------|
| SSH_PRIVATE_KEY | base64 encoded content of private key that can clone the `EXPORT_GIT_URL`                          |
| GIT_USERNAME    | The user name that will be tied to the git commit (This doesn't have to be a real GitHub user)     |
| GIT_USER_EMAIL  | The email address that will be tied to the git commit (This doesn't have to be a real GitHub user) |

### Required Environment Variables (runtime)

See [.env.example](./.env.example).

## Stretch Goals

If the application detects a configuration change - it will commit the code to a branch and open a pull request. This alerts team mates about the configuration change and gives the chance to review it.
