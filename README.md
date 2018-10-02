# API Gateway Exporter

We want to keep the [API gateway configuration](https://docs.aws.amazon.com/cli/latest/reference/apigateway/get-export.html), for each stage, under source control.  
This app can be called by a scheduler and:

1.  Download the API configuration.
2.  Commit it to source control it's changed since the last run.

## Installing / Running Locally

### Installing

1.  `cp .env.example .env`
2.  `docker-compose build`
3.  `docker-compose up`

### Debugging

You can run the container and use pry.
To get into the container run `docker-compose run gateway_exporter bash`.  
Then, inside the container: `cd /opt/api_gateway_exporter && ./bin/export.rb`

## Deployment

Build args:

| Name            | Description                                                               |
|:----------------|:--------------------------------------------------------------------------|
| SSH_PRIVATE_KEY | base64 encoded content of private key that can clone the `EXPORT_GIT_URL` |

## Stretch Goals

If the application detects a configuration change - it will commit the code to a branch and open a pull request. This alerts team mates about the configuration change and gives the chance to review it.
