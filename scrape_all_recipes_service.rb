require 'nokogiri'
require_relative 'recipe'
require 'open-uri'

class ScrapeAllRecipesService
  class << self
    def retrieve(url)
      file = Nokogiri::HTML(URI.open(url).read, nil, 'utf-8')
      file.search('.card__detailsContainer').first(5).map do |recipe|
        args = {}
        args[:name] = recipe.search('.card__title').text.strip
        args[:description] = recipe.search('.card__summary').text.strip
        args[:rating] = recipe.search('.review-star-text').text.strip.match(/\d\.?\d{,2}/)
        args[:prep_time] = fetch_prep(recipe.search('.card__titleLink').attribute('href').value)
        Recipe.new(**args)
      end
    end

    private

    def fetch_prep(url)
      file = Nokogiri::HTML(URI.open(url).read, nil, 'utf-8')
      file.search('.recipe-meta-item-body').first.text.strip
    end
  end
end

# .split(/(?<=[!.?]) /).map(&:capitalize).join(' ')
