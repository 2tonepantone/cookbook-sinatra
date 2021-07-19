require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require_relative 'cookbook'
require_relative 'recipe'
require_relative 'scrape_all_recipes_service'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end

cookbook = Cookbook.new('./recipes.csv')
URL = "https://www.allrecipes.com/search/results/?search="
searched = []

get '/' do
  @recipes = cookbook.all
  erb :index
end

get '/recipes/new' do
  erb :new
end

post '/recipes/create' do
  recipe = Recipe.new(**params)
  cookbook.add_recipe(recipe)
  redirect to('/')
end

# localhost:4567/recipes/delete/1
# params => { "id" => '1' }
get '/recipes/delete/:id' do
  cookbook.remove_recipe(params[:id].to_i)
  redirect to('/')
end

get '/recipes/complete/:id' do
  cookbook.mark_recipe_done(params[:id].to_i)
  redirect to('/')
end

get '/recipes/search' do
  @keyword = params[:keyword]
  @recipes = ScrapeAllRecipesService.retrieve(URL + params[:keyword])
  searched = @recipes
  erb :results
end

# get '/recipes/import/:id' do
#   binding.pry
#   recipe = searched[params[:id].to_i]
#   cookbook.add_recipe(recipe)
#   redirect to('/')
# end
