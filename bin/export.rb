#!/usr/local/bin/ruby -w
require 'nypl_log_formatter'
require 'yaml'

# Get useful paths
WORKSPACE_DIR = '/opt/git_working_directory'.freeze
repository_dir_name = File.basename(ENV['EXPORT_GIT_URL'], '.*')
FULL_PATH_TO_REPO_DIR = File.join(WORKSPACE_DIR, repository_dir_name)

# Load stages.yml
stages = YAML.load_file(File.join(__dir__, '..', 'stages.yml'))
require 'pry'; binding.pry;
logger = NyplLogFormatter.new(STDOUT)

# Clone the git repo where the backups are stored
logger.info("Cloning #{ENV['EXPORT_GIT_URL']} to #{WORKSPACE_DIR}")
`cd #{WORKSPACE_DIR} && git clone #{ENV['EXPORT_GIT_URL']}`

# Thar be psudocode below
stages.each do |stage|
  path_to_stage_export = File.join(WORKSPACE_DIR, "#{stage['name']}.json")
  if !File.exist?(path_to_stage_export)
    logger.info("#{path_to_stage_export}.json doesn't exist, saving first copy")
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
