class ApiFillDatabase

  attr_reader :api_url, :api_key, :limit

  def initialize
    @api_url = Rails.application.credentials.dig(:secrets, :api, :url)
    @api_key = Rails.application.credentials.dig(:secrets, :api, :key)
    @limit = Rails.application.credentials.dig(:secrets, :api, :limit)
  end

  def fill
    sources = fetch_articles_sources_from_api({ country: 'us', apiKey: @api_key }, 'sources',)
    articles = fetch_articles_from_api({ country: 'us', apiKey: @api_key })

    if sources.present? && articles.present?

      begin
        ActiveRecord::Base.transaction do

          articles.take(@limit).each do |article|

            article_source_name = article['source']['name']
            source_info = sources.find { |source| source['name'].eql?(article_source_name) }

            next unless source_info

            source = Source.find_or_create_by!(
              name: source_info['name'],
              description: source_info['description'],
              url: source_info['url'],
              category: source_info['category'],
              language: source_info['language'],
              country: source_info['country']
            )

            Article.find_or_create_by!(
              author: article['author'],
              title: article['title'],
              description: article['description'],
              url: article['url'],
              urlToImage: article['urlToImage'],
              publishedAt: article['publishedAt'],
              content: article['content'],
              source_id: source.id
            )
          end
        end
      rescue => e
        Rails.logger.error "Error: Cannot possible fill the database: #{e.message}"
        raise e
      end
    end
  end

  def fetch_articles_sources_from_api(params = {}, path = '')
    response = ApiHttpClient.fetch(@api_url, path, params)
    JSON.parse(response.body)['sources']
  end

  def fetch_articles_from_api(params = {}, path = '')
    response = ApiHttpClient.fetch(@api_url, path, params)
    JSON.parse(response.body)['articles']
  end

end
