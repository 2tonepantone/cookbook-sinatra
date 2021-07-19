require 'nokogiri'
require_relative 'recipe'
require 'open-uri'

class ScrapeAllRecipesService
  def self.retrieve(url)
    file = Nokogiri::HTML(URI.open(url).read, nil, 'utf-8')
    file.search('.card__detailsContainer').first(5).map do |recipe|
      title = recipe.search('.card__title').text.strip
      description = recipe.search('.card__summary').text.strip
      rating = recipe.search('.review-star-text').text.strip.match(/\d\.?\d?\d?/)
      prep_time = fetch_prep(recipe.search('.card__titleLink').attribute('href').value)
      Recipe.new(title, description, prep_time, rating)
    end
  end

  def self.fetch_prep(url)
    file = Nokogiri::HTML(URI.open(url).read, nil, 'utf-8')
    file.search('.recipe-meta-item-body').first.text.strip
  end
end

# .split(/(?<=[!.?]) /).map(&:capitalize).join(' ')
