#!/usr/local/bin/ruby -w
require 'nypl_log_formatter'
require 'aws-sdk-apigateway'
require 'json'

logger = NyplLogFormatter.new(STDOUT)
# Get useful paths
WORKSPACE_DIR = '/opt/git_working_directory'.freeze
repository_dir_name = File.basename(ENV['EXPORT_GIT_URL'], '.*')
FULL_PATH_TO_REPO_DIR = File.join(WORKSPACE_DIR, repository_dir_name)

# Load stages.yml
stages = JSON.parse(ENV['STAGES'])

# A factory method that returns an Aws::APIGateway::Client configured with the correct
# region and auth credentials
def get_agent(stage)
  options = { region: stage['region'] || 'us-east-1' }
  %w[access_key_id secret_access_key].each do |param|
    options.merge!(param.to_sym => stage[param]) if stage[param]
  end
  Aws::APIGateway::Client.new(options)
end

#
def get_export_for(stage, api_gateway_client)
  resp = api_gateway_client.get_export(
    rest_api_id: stage['rest_api_id'],
    stage_name:  stage['name'],
    export_type: 'swagger',
    parameters: {
      'extensions' => '"integrations,authorizers,apigateway'
    },
    accepts: 'application/json'
  )
  resp.body.read
end

def write_and_commit(options = {})
  # logger.info("writing export of stage #{options['stage']} to #{options['path_to_file']}")
  File.open(options[:path_to_file], 'w') {|f| f.write(options[:export_string]) }
  `cd #{FULL_PATH_TO_REPO_DIR} && git commit -am 'Updating contents of #{File.basename(options[:path_to_file], '.*')}'`
  # TODO: Git push
end

# Clone the git repo where the backups are stored
logger.info("Cloning #{ENV['EXPORT_GIT_URL']} to #{WORKSPACE_DIR}")
`cd #{WORKSPACE_DIR} && git clone #{ENV['EXPORT_GIT_URL']}`

# Thar be psudocode below
stages.each do |stage|
  api_gateway_client = get_agent(stage)
  path_to_stage_export = File.join(FULL_PATH_TO_REPO_DIR, "#{stage['name']}.json")
  if !File.exist?(path_to_stage_export)
    logger.info("#{path_to_stage_export}.json doesn't exist, saving first copy")
    export = get_export_for(stage, api_gateway_client)
    write_and_commit(stage: stage, export_string: export, path_to_file: path_to_stage_export)
    # write file
    # add/commit/push
  else
    # export latest API.
    # if different?
    #   logger.info("#{filename} has changed, comitting changes")
    #   write file
    #   add/commit/push
    # else
    #   logger.info("#{filename} has not changed since last run")
    # end
  end
end
