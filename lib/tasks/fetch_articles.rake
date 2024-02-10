namespace :fetch_articles do
  desc "Fetch articles from NewsAPI.org and fill the database with a command"
  task :fill_database => :environment do
    ApiFillDatabase.new.fill
    Rails.logger.info "Database filled with articles and sources."
  end
end