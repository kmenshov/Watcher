task setup_logger: :environment do
  logger       = Logger.new(STDOUT)
  logger.level = Logger::DEBUG
  Rails.logger = logger
end

desc 'Executes all recipes and adds new fetched results to the database'
task rewatch: :setup_logger do
  puts '--- Rewatch started ---'
  Recipe.rewatch
  puts '--- Rewatch complete ---'
end